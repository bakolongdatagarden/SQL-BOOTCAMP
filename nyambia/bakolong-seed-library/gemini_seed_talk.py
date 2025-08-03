# Requirements:
# streamlit, mysql-connector-python, pandas, python-dotenv, google-generativeai

import streamlit as st
import mysql.connector
import pandas as pd
from datetime import date
import re

# Google Gemini Integration
try:
    import google.generativeai as genai
    GEMINI_AVAILABLE = True
except ImportError:
    GEMINI_AVAILABLE = False
    st.warning("Install Google Gemini: pip install google-generativeai")

class SeedLibraryAssistant:
    def __init__(self, api_key=None):
        self.connection = None
        self.gemini_model = None

        if GEMINI_AVAILABLE and api_key:
            try:
                genai.configure(api_key=api_key)
                self.gemini_model = genai.GenerativeModel('models/gemini-1.5-flash-latest')
                st.success("🚀 Gemini AI connected successfully!")
            except Exception as e:
                st.error(f"Gemini setup error: {e}")
                self.gemini_model = None

    def get_db_connection(self):
        try:
            connection = mysql.connector.connect(
                host=st.secrets["database"]["DB_HOST"],
                port=int(st.secrets["database"]["DB_PORT"]),
                user=st.secrets["database"]["DB_USER"],
                password=st.secrets["database"]["DB_PASSWORD"],
                database=st.secrets["database"]["DB_NAME"]
            )
            return connection
        except mysql.connector.Error as err:
            st.error(f"Database connection failed: {err}")
            return None

    def get_database_context(self):
        connection = self.get_db_connection()
        if not connection:
            return None
        try:
            cursor = connection.cursor()
            cursor.execute("DESCRIBE seed_packs")
            schema = cursor.fetchall()
            cursor.execute("SELECT * FROM seed_packs LIMIT 5")
            sample_data = cursor.fetchall()
            cursor.execute("SELECT DISTINCT plant_type FROM seed_packs")
            plant_types = [row[0] for row in cursor.fetchall()]
            cursor.execute("SELECT DISTINCT quantity FROM seed_packs")
            quantities = [row[0] for row in cursor.fetchall()]
            cursor.execute("SELECT DISTINCT seed_source FROM seed_packs")
            sources = [row[0] for row in cursor.fetchall()]
            cursor.execute("SELECT COUNT(*) FROM seed_packs")
            total_count = cursor.fetchone()[0]
            context = f"""
            DATABASE CONTEXT:
            Table: seed_packs
            Total Records: {total_count}
            SCHEMA:
            """
            for col in schema:
                context += f"- {col[0]} ({col[1]}): {col[2]} {col[3] if col[3] else ''}\n"
            context += f"""
            CONSTRAINTS:
            - plant_type must be one of: {plant_types}
            - quantity must be one of: {quantities}
            - seed_source options include: {sources}
            SAMPLE DATA:
            """
            for row in sample_data[:3]:
                context += f"{row}\n"
            return context
        except mysql.connector.Error as err:
            st.error(f"Error getting database context: {err}")
            return None
        finally:
            cursor.close()
            connection.close()

    def generate_agricultural_advice(self, question, data_context=""):
        """Generate hybrid advice using both database and general knowledge"""
        if not self.gemini_model:
            return "⚠️ Enable Gemini API for advanced advice"
        prompt = f"""
        ROLE: Agricultural expert with seed database access

        DATABASE CONTEXT (if relevant):
        {data_context}

        QUESTION: {question}

        RESPONSE RULES:
        1. FIRST check if database context answers the question directly
        2. For general knowledge, begin with "🌿 Agricultural Tip:"
        3. For companion planting, use format:
           - 👍 Good Companions: [plants] (benefits)
           - 👎 Avoid: [plants] (reasons)
        4. For planting advice, include:
           - 📅 Ideal season
           - ☀️ Sun requirements
           - 💧 Water needs
        5. Flag assumptions with "⚠️ Note:"

        ANSWER:
        """
        try:
            response = self.gemini_model.generate_content(prompt)
            return response.text
        except Exception as e:
            return f"Error generating advice: {e}"

    def get_companion_analysis(self, plant_name, data_context=""):
        """Specialized companion planting analysis"""
        if not self.gemini_model:
            return "⚠️ Gemini AI is not enabled."
        prompt = f"""
        Analyze companion plants for {plant_name} considering:

        DATABASE CONTEXT:
        {data_context}

        OUTPUT FORMAT:
        ### Companion Planting for {plant_name}

        **Ideal Partners**:
        - [Plant 1]: [Benefits]
        - [Plant 2]: [Benefits]

        **Avoid Planting With**:
        - [Plant 1]: [Reasons]

        **Additional Tips**:
        - [Tip 1]
        - [Tip 2]

        Include specific varieties from database if available.
        """
        try:
            response = self.gemini_model.generate_content(prompt)
            return response.text
        except Exception as e:
            return f"Error generating companion analysis: {e}"

    def text_to_sql(self, user_question):
        """Convert natural language question to SQL query"""
        prompt = f"""
        You are a SQL expert. Convert the user's question into a SQL query for the seed database.

        SCHEMA:
        Table: seed_packs
        Columns: id, seed_name, plant_type, quantity, seed_source, date_acquired

        USER QUESTION: {user_question}

        SQL QUERY:
        """
        try:
            response = self.gemini_model.generate_content(prompt)
            return response.text.strip()
        except Exception as e:
            return f"Error generating SQL query: {e}"

    def execute_sql_query(self, query):
        connection = self.get_db_connection()
        if not connection:
            return None
        try:
            df = pd.read_sql(query, connection)
            return df
        except Exception as e:
            st.error(f"Error executing query: {e}")
            return None
        finally:
            connection.close()

def clean_sql(sql):
    import re
    sql = re.sub(r"```sql\s*", "", sql, flags=re.IGNORECASE)
    sql = re.sub(r"```", "", sql)
    return sql.strip()

def is_valid_sql(sql, allowed_tables, allowed_columns):
    import re
    # Check for allowed table names
    for table in re.findall(r'from\s+([a-zA-Z0-9_]+)', sql, re.IGNORECASE):
        if table not in allowed_tables:
            return False, f"Invalid table referenced: {table}"
    # Check for allowed column names (simple check)
    for col in re.findall(r'select\s+(.*?)\s+from', sql, re.IGNORECASE):
        for c in col.split(','):
            c = c.strip().split(' ')[0]  # Remove aliases
            if c != '*' and c not in allowed_columns:
                return False, f"Invalid column referenced: {c}"
    return True, ""

# Allowed tables and columns for SQL validation
ALLOWED_TABLES = {'seed_packs'}
ALLOWED_COLUMNS = {'id', 'seed_name', 'plant_type', 'quantity', 'seed_source', 'date_acquired'}

def main():
    # ===== UI REDESIGN =====
    st.set_page_config(
        page_title="Seed Sage", 
        page_icon="🌱",
        layout="wide"
    )

    # Sidebar Setup
    with st.sidebar:
        st.image("https://i.imgur.com/JiZQZ9C.png", width=150)  # Add your logo
        st.header("🔑 Setup")
        api_key = st.text_input(
            "Gemini API Key", 
            type="password",
            value=st.secrets.get("API_KEY", ""),
            help="Get free key from https://makersuite.google.com/app/apikey"
        )
        if not api_key:
            api_key = st.secrets["API_KEY"]
        st.divider()
        st.header("🌿 Quick Actions")
        if st.button("View Companion Planting Guide"):
            st.session_state.current_view = "companion_guide"
        if st.button("Return to Main Chat"):
            st.session_state.current_view = "main_chat"

    # Initialize assistant
    if 'assistant' not in st.session_state:
        st.session_state.assistant = SeedLibraryAssistant(api_key)
    # Ensure current_view is always set
    if 'current_view' not in st.session_state:
        st.session_state.current_view = "main_chat"

    # ===== MAIN VIEW =====
    if st.session_state.get('current_view', 'main_chat') == "main_chat":
        st.title("🌿 Seed Sage")
        st.caption("Your AI-Powered Seed Library Assistant")

        # Enhanced Question Input
        with st.container(border=True):
            user_question = st.text_input(
                "Ask anything about your seeds:",
                placeholder="e.g. 'What grows well with my tomatoes?' or 'Show herbs I can plant now'"
            )

            # Quick Suggestions
            cols = st.columns(4)
            with cols[0]:
                if st.button("Companion Plants", help="Get planting partners"):
                    user_question = "Companion planting guide"
            with cols[1]:
                if st.button("Planting Schedule", help="What to plant now"):
                    user_question = "Current planting schedule"
            with cols[2]:
                if st.button("Low Stock", help="Seeds needing replenishment"):
                    user_question = "Which seeds are running low?"
            with cols[3]:
                if st.button("Collection Stats", help="Database overview"):
                    user_question = "Show collection statistics"

        # Response Area
        if user_question:
            with st.spinner("🌱 Consulting the garden wisdom..."):
                # Check if question requires general knowledge
                general_knowledge_triggers = [
                    'companion', 'grow with', 'plant with', 
                    'schedule', 'when to plant', 'season'
                ]
                if any(trigger in user_question.lower() for trigger in general_knowledge_triggers):
                    # Get database context if available
                    db_context = ""
                    if "my" in user_question.lower() or re.search(r'\b(herbs|vegetables|flowers)\b', user_question.lower()):
                        db_context = st.session_state.assistant.get_database_context() or ""
                    response = st.session_state.assistant.generate_agricultural_advice(
                        user_question, 
                        db_context
                    )
                    st.markdown(f"### 🌻 Growing Advice")
                    st.markdown(response)
                else:
                    # Original database query flow
                    sql_query = st.session_state.assistant.text_to_sql(user_question)
                    if sql_query:
                        sql_query = clean_sql(sql_query)
                        is_valid, reason = is_valid_sql(sql_query, ALLOWED_TABLES, ALLOWED_COLUMNS)
                        if not is_valid:
                            st.error(f"⚠️ {reason}. Please rephrase your question.")
                        else:
                            with st.expander("🔍 Generated Query", expanded=False):
                                st.code(sql_query)
                            results_df = st.session_state.assistant.execute_sql_query(sql_query)
                            if results_df is not None:
                                st.dataframe(results_df, use_container_width=True)
                                # Enhanced insights
                                st.markdown("### 📊 Insights")
                                insights = st.session_state.assistant.generate_agricultural_advice(
                                    f"Analyze these results: {results_df.head(3).to_dict()}\nOriginal question: {user_question}"
                                )
                                st.markdown(insights)

    # ===== COMPANION PLANTING GUIDE VIEW =====
    else:
        st.title("🌼 Companion Planting Guide")
        # Get all plant types from database
        connection = st.session_state.assistant.get_db_connection()
        if connection:
            try:
                cursor = connection.cursor()
                cursor.execute("SELECT DISTINCT seed_name FROM seed_packs")
                seed_options = [row[0] for row in cursor.fetchall()]
                if seed_options:
                    selected_plant = st.selectbox(
                        "Select a plant from your collection:",
                        options=seed_options,
                        index=0
                    )
                    if st.button("Generate Companion Guide"):
                        with st.spinner(f"Finding ideal partners for {selected_plant}..."):
                            db_context = st.session_state.assistant.get_database_context()
                            advice = st.session_state.assistant.get_companion_analysis(
                                selected_plant,
                                db_context
                            )
                            st.markdown(advice)
            finally:
                cursor.close()
                connection.close()

if __name__ == "__main__":
    main()