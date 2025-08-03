import streamlit as st
import mysql.connector
import pandas as pd
from datetime import date
import re
import os
from dotenv import load_dotenv

# Load environment variables from .env
load_dotenv()

# Google Gemini Integration (official package only)
try:
    import google.generativeai as genai
    GEMINI_AVAILABLE = True
except ImportError:
    GEMINI_AVAILABLE = False
    st.warning("Install Google Gemini: pip install google-generativeai")

class GeminiDatabaseChat:
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
        elif not api_key:
            st.info("💡 Add your Gemini API key to enable AI features")
    
    def get_db_connection(self):
        try:
            connection = mysql.connector.connect(
                host='localhost',
                port=3306,
                user='root',
                password='Bakolong999.',
                database='bakolong_seed_library'
            )
            return connection
        except mysql.connector.Error as err:
            st.error(f"Database connection failed: {err}")
            return None
    
    def get_database_context(self):
        """Get comprehensive database context for Gemini"""
        connection = self.get_db_connection()
        if not connection:
            return None
            
        try:
            cursor = connection.cursor()
            
            # Get schema
            cursor.execute("DESCRIBE seed_packs")
            schema = cursor.fetchall()
            
            # Get sample data
            cursor.execute("SELECT * FROM seed_packs LIMIT 5")
            sample_data = cursor.fetchall()
            
            # Get distinct values for constraints
            cursor.execute("SELECT DISTINCT plant_type FROM seed_packs")
            plant_types = [row[0] for row in cursor.fetchall()]
            
            cursor.execute("SELECT DISTINCT quantity FROM seed_packs")
            quantities = [row[0] for row in cursor.fetchall()]
            
            cursor.execute("SELECT DISTINCT seed_source FROM seed_packs")
            sources = [row[0] for row in cursor.fetchall()]
            
            # Get total count
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
            
            for row in sample_data[:3]:  # Show first 3 rows
                context += f"{row}\n"
            
            return context
            
        except mysql.connector.Error as err:
            st.error(f"Error getting database context: {err}")
            return None
        finally:
            cursor.close()
            connection.close()
    
    def gemini_text_to_sql(self, user_question):
        """Use Gemini to convert natural language to SQL"""
        if not self.gemini_model:
            return None
            
        db_context = self.get_database_context()
        if not db_context:
            return None
        
        prompt = f"""
        You are an expert SQL developer helping with an agricultural seed library database.
        
        {db_context}
        
        IMPORTANT RULES:
        1. Return ONLY the SQL query, no explanations or markdown
        2. Use MySQL syntax
        3. Always use proper column names from the schema above
        4. For LIKE searches, use proper wildcards (%)
        5. Be case-sensitive with ENUM values
        6. Use proper date formats for date_acquired column
        
        AGRICULTURAL CONTEXT:
        This is a personal seed collection for gardening/farming. Users want to:
        - Track their seed inventory
        - Plan planting schedules
        - Manage seed sources and quantities
        - Analyze their collection for agricultural decisions
        
        USER QUESTION: {user_question}
        
        SQL QUERY:"""
        
        try:
            response = self.gemini_model.generate_content(prompt)
            sql_query = response.text.strip()
            
            # Clean up the response
            # Remove markdown code blocks if present
            sql_query = re.sub(r'```sql\n?', '', sql_query)
            sql_query = re.sub(r'```\n?', '', sql_query)
            
            # Remove extra whitespace and comments
            sql_query = re.sub(r'--.*\n', '', sql_query)
            sql_query = sql_query.strip()
            
            # Validate it looks like SQL
            if not sql_query.upper().startswith(('SELECT', 'SHOW', 'DESCRIBE', 'EXPLAIN')):
                return None
                
            return sql_query
            
        except Exception as e:
            st.error(f"Gemini API error: {e}")
            return None
    
    def enhanced_pattern_matching(self, user_question):
        """Fallback enhanced pattern matching for agricultural queries"""
        question_lower = user_question.lower()
        
        # Agricultural-focused patterns with more sophistication
        patterns = {
            # Inventory Management
            r"(how many|count|total).*seed": 
                "SELECT COUNT(*) as total_seed_packs FROM seed_packs;",
            
            r"(how many|count).*vegetable": 
                "SELECT COUNT(*) as vegetable_count FROM seed_packs WHERE plant_type = 'Vegetable';",
            
            r"(how many|count).*herb": 
                "SELECT COUNT(*) as herb_count FROM seed_packs WHERE plant_type = 'Herb';",
            
            r"(how many|count).*flower": 
                "SELECT COUNT(*) as flower_count FROM seed_packs WHERE plant_type = 'Flower';",
            
            # Collection Viewing
            r"(show|list|display).*(all|my).*vegetable": 
                "SELECT * FROM seed_packs WHERE plant_type = 'Vegetable' ORDER BY seed_name;",
            
            r"(show|list|display).*(all|my).*herb": 
                "SELECT * FROM seed_packs WHERE plant_type = 'Herb' ORDER BY seed_name;",
            
            r"(show|list|display).*(all|my).*flower": 
                "SELECT * FROM seed_packs WHERE plant_type = 'Flower' ORDER BY seed_name;",
            
            r"(show|list|display).*(all|my).*fruit": 
                "SELECT * FROM seed_packs WHERE plant_type = 'Fruit' ORDER BY seed_name;",
            
            # Quantity-based Agricultural Planning
            r"(bulk|lots|plenty|abundant).*seed": 
                "SELECT * FROM seed_packs WHERE quantity IN ('Bulk (200+)', 'Lots (76-200)') ORDER BY plant_type, seed_name;",
            
            r"(few|low|running low|need more).*seed": 
                "SELECT * FROM seed_packs WHERE quantity IN ('Very Few (1-5)', 'Few (6-20)') ORDER BY plant_type, seed_name;",
            
            r"ready.*(plant|sow)|plant.*ready": 
                "SELECT * FROM seed_packs WHERE quantity NOT IN ('Very Few (1-5)') ORDER BY plant_type, quantity DESC;",
            
            # Source Analysis
            r"(dpl|library|dallas.*public)": 
                "SELECT * FROM seed_packs WHERE seed_source = 'DPL Seed Library' ORDER BY date_acquired DESC;",
            
            r"(purchased|bought|burpee)": 
                "SELECT * FROM seed_packs WHERE seed_source LIKE '%Purchased%' OR seed_source LIKE '%Burpee%' ORDER BY date_acquired DESC;",
            
            # Temporal Analysis
            r"(recent|latest|newest|new).*seed": 
                "SELECT * FROM seed_packs ORDER BY date_acquired DESC LIMIT 10;",
            
            r"(oldest|first|original).*seed": 
                "SELECT * FROM seed_packs ORDER BY date_acquired ASC LIMIT 10;",
            
            r"this.*year|2025": 
                "SELECT * FROM seed_packs WHERE YEAR(date_acquired) = 2025 ORDER BY date_acquired DESC;",
            
            r"last.*month": 
                "SELECT * FROM seed_packs WHERE date_acquired >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH) ORDER BY date_acquired DESC;",
            
            # Specific Crop Searches
            r"tomato": 
                "SELECT * FROM seed_packs WHERE seed_name LIKE '%tomato%' OR seed_name LIKE '%Tomato%' ORDER BY variety;",
            
            r"pepper": 
                "SELECT * FROM seed_packs WHERE seed_name LIKE '%pepper%' OR seed_name LIKE '%Pepper%' ORDER BY variety;",
            
            r"bean": 
                "SELECT * FROM seed_packs WHERE seed_name LIKE '%bean%' OR seed_name LIKE '%Bean%' ORDER BY variety;",
            
            r"lettuce": 
                "SELECT * FROM seed_packs WHERE seed_name LIKE '%lettuce%' OR seed_name LIKE '%Lettuce%' ORDER BY variety;",
            
            # Agricultural Analysis
            r"(summary|overview|stats|statistics|analysis)": 
                """SELECT 
                    plant_type, 
                    COUNT(*) as variety_count,
                    SUM(CASE WHEN quantity IN ('Bulk (200+)', 'Lots (76-200)') THEN 1 ELSE 0 END) as high_quantity,
                    GROUP_CONCAT(DISTINCT seed_source) as sources
                   FROM seed_packs 
                   GROUP BY plant_type 
                   ORDER BY variety_count DESC;""",
            
            r"(diversity|variety|types)": 
                "SELECT plant_type, COUNT(DISTINCT seed_name) as unique_varieties FROM seed_packs GROUP BY plant_type ORDER BY unique_varieties DESC;",
            
            # Seed Source Analysis
            r"source.*analysis|where.*from": 
                "SELECT seed_source, COUNT(*) as seed_count, GROUP_CONCAT(DISTINCT plant_type) as plant_types FROM seed_packs GROUP BY seed_source ORDER BY seed_count DESC;",
        }
        
        for pattern, sql in patterns.items():
            if re.search(pattern, question_lower):
                return sql
        
        return None
    
    def text_to_sql(self, user_question):
        """Main method to convert text to SQL using Gemini or fallback"""
        # Try Gemini first if available
        if self.gemini_model:
            sql = self.gemini_text_to_sql(user_question)
            if sql:
                return sql
        
        # Fallback to enhanced pattern matching
        return self.enhanced_pattern_matching(user_question)
    
    def execute_sql_query(self, sql_query):
        """Execute SQL query safely and return results"""
        connection = self.get_db_connection()
        if connection:
            try:
                cursor = connection.cursor()
                cursor.execute(sql_query)
                results = cursor.fetchall()
                columns = [desc[0] for desc in cursor.description]
                return pd.DataFrame(results, columns=columns)
            except mysql.connector.Error as err:
                st.error(f"SQL Error: {err}")
                return None
            finally:
                cursor.close()
                connection.close()
        return None
    
    def generate_agricultural_insights(self, df, original_question, use_ai=True):
        """Generate insights using Gemini or rule-based analysis"""
        if df is None or df.empty:
            return "No seeds found matching your criteria."
        
        # Try AI-powered insights first
        if use_ai and self.gemini_model:
            return self.gemini_generate_insights(df, original_question)
        
        # Fallback to rule-based insights
        return self.rule_based_insights(df, original_question)
    
    def gemini_generate_insights(self, df, original_question):
        """Use Gemini to generate agricultural insights"""
        try:
            # Prepare data summary for Gemini
            data_summary = f"""
            Query Results Summary:
            - Total records: {len(df)}
            - Columns: {list(df.columns)}
            - Sample data: {df.head(3).to_dict('records') if len(df) > 0 else 'No data'}
            """
            
            if 'plant_type' in df.columns:
                data_summary += f"\n- Plant types: {df['plant_type'].value_counts().to_dict()}"
            
            if 'quantity' in df.columns:
                data_summary += f"\n- Quantities: {df['quantity'].value_counts().to_dict()}"
            
            prompt = f"""
            You are an agricultural advisor analyzing a seed collection database.
            
            Original Question: {original_question}
            
            {data_summary}
            
            Provide 3-5 concise, actionable insights for a home gardener/farmer:
            1. Focus on agricultural planning and decisions
            2. Mention planting recommendations if relevant
            3. Note any inventory management suggestions
            4. Keep it practical and specific to the data
            5. Use agricultural terminology appropriately
            
            Format as bullet points with emojis.
            """
            
            response = self.gemini_model.generate_content(prompt)
            return response.text.strip()
            
        except Exception as e:
            st.error(f"Error generating AI insights: {e}")
            return self.rule_based_insights(df, original_question)
    
    def rule_based_insights(self, df, original_question):
        """Generate rule-based agricultural insights"""
        insights = []
        
        # Basic count insight
        if len(df) == 1 and any('count' in col.lower() for col in df.columns):
            count_col = [col for col in df.columns if 'count' in col.lower()][0]
            insights.append(f"🌱 Total: {df.iloc[0][count_col]} seed varieties")
        else:
            insights.append(f"🌱 Found {len(df)} seed entries in your collection")
        
        # Plant type analysis
        if 'plant_type' in df.columns:
            plant_types = df['plant_type'].value_counts()
            most_common = plant_types.index[0] if len(plant_types) > 0 else None
            insights.append(f"🌿 Most common type: {most_common} ({plant_types.iloc[0]} varieties)")
            
            if len(plant_types) > 1:
                insights.append(f"🌾 Crop diversity: {len(plant_types)} different plant types")
        
        # Quantity-based planting advice
        if 'quantity' in df.columns:
            high_qty = len(df[df['quantity'].str.contains('Bulk|Lots', na=False)])
            low_qty = len(df[df['quantity'].str.contains('Very Few', na=False)])
            
            if high_qty > 0:
                insights.append(f"🚀 {high_qty} varieties ready for large-scale planting")
            if low_qty > 0:
                insights.append(f"⚠️ {low_qty} varieties running low - consider restocking")
        
        # Seasonal insights
        if 'date_acquired' in df.columns:
            recent = len(df[pd.to_datetime(df['date_acquired'], errors='coerce') > pd.Timestamp.now() - pd.Timedelta(days=60)])
            if recent > 0:
                insights.append(f"🆕 {recent} recently acquired varieties (last 60 days)")
        
        # Source diversity
        if 'seed_source' in df.columns:
            sources = df['seed_source'].nunique()
            if sources > 1:
                insights.append(f"📦 Sourced from {sources} different suppliers")
        
        return "\n".join(insights)

def main():
    st.title("🌱🤖 Gemini-Powered Seed Library Chat")
    st.subheader("Free AI for your agricultural data!")
    
    # API Key input
    st.sidebar.header("🔑 Gemini API Setup")
    api_key_input = st.sidebar.text_input(
        "Enter your Gemini API Key", 
        type="password",
        help="Get free API key from https://makersuite.google.com/app/apikey"
    )

    # Use .env API key if sidebar input is blank
    api_key = api_key_input or os.getenv("API_KEY")

    if not api_key:
        st.sidebar.info("""
        **Get your free Gemini API key:**
        1. Visit https://makersuite.google.com/app/apikey
        2. Sign in with Google account
        3. Create new API key
        4. Paste it above
        
        **Free tier includes:**
        - 15 requests/minute
        - 1,500 requests/day
        - Perfect for personal use!
        """)
    
    # Initialize chatbot
    if 'chatbot' not in st.session_state or st.session_state.get('api_key') != api_key:
        st.session_state.chatbot = GeminiDatabaseChat(api_key)
        st.session_state.api_key = api_key
    
    # Show connection status
    if api_key and GEMINI_AVAILABLE:
        st.success("🚀 Gemini AI enabled! Ask sophisticated questions about your seeds.")
    elif api_key and not GEMINI_AVAILABLE:
        st.error("Please install: pip install google-generativeai")
    else:
        st.warning("🔧 Add API key for AI features, or use pattern matching mode")
    
    # Agricultural example questions
    with st.expander("🌾 Try these agricultural questions"):
        col1, col2 = st.columns(2)
        
        with col1:
            st.markdown("""
            **Inventory & Planning:**
            - What vegetables should I plant this month?
            - Which seeds are running low?
            - Show me all herbs with good quantities
            - What's my seed collection diversity?
            """)
        
        with col2:
            st.markdown("""
            **Analysis & Insights:**
            - Analyze my seed sources
            - What crops can I plant in bulk?
            - Show recent acquisitions
            - Compare my vegetable vs herb collection
            """)
    
    # Main chat interface
    user_question = st.text_input(
        "Ask about your seed collection:", 
        placeholder="e.g., What vegetables do I have enough seeds to plant a large garden?"
    )
    
    if user_question:
        with st.spinner("🧠 Gemini AI analyzing your agricultural question..."):
            sql_query = st.session_state.chatbot.text_to_sql(user_question)
            
            if sql_query:
                # Show generated SQL
                with st.expander("📝 Generated SQL Query"):
                    st.code(sql_query, language="sql")
                
                # Execute query
                results_df = st.session_state.chatbot.execute_sql_query(sql_query)
                
                if results_df is not None and not results_df.empty:
                    st.write("**Query Results:**")
                    st.dataframe(results_df, use_container_width=True)
                    
                    # Generate insights
                    st.write("**Agricultural Insights:**")
                    insights = st.session_state.chatbot.generate_agricultural_insights(
                        results_df, user_question, use_ai=bool(api_key)
                    )
                    st.info(insights)
                    
                    # Suggest follow-up questions
                    if api_key and st.session_state.chatbot.gemini_model:
                        with st.expander("💡 Suggested follow-up questions"):
                            try:
                                follow_up_prompt = f"""
                                Based on this seed library query: "{user_question}"
                                And these results: {len(results_df)} records found
                                
                                Suggest 3 practical follow-up questions a gardener might ask.
                                Keep them concise and agricultural-focused.
                                """
                                
                                follow_up = st.session_state.chatbot.gemini_model.generate_content(follow_up_prompt)
                                st.write(follow_up.text)
                            except:
                                st.write("Try asking about planting schedules, companion crops, or seed storage!")
                
                else:
                    st.warning("No results found. Try rephrasing your question or check if you have data in your database.")
            else:
                st.error("I couldn't understand that question. Try using the examples above or rephrasing.")
    
    # Quick agricultural dashboard
    st.header("🌾 Agricultural Dashboard")
    col1, col2 = st.columns(2)
    
    with col1:
        if st.button("📊 Collection Overview"):
            overview_query = """
            SELECT 
                plant_type,
                COUNT(*) as varieties,
                SUM(CASE WHEN quantity IN ('Bulk (200+)', 'Lots (76-200)') THEN 1 ELSE 0 END) as ready_to_plant
            FROM seed_packs 
            GROUP BY plant_type 
            ORDER BY varieties DESC
            """
            df = st.session_state.chatbot.execute_sql_query(overview_query)
            if df is not None and not df.empty:
                st.dataframe(df)
    
    with col2:
        if st.button("📈 Planting Readiness"):
            readiness_query = """
            SELECT 
                quantity,
                COUNT(*) as seed_packs,
                GROUP_CONCAT(DISTINCT plant_type) as plant_types
            FROM seed_packs 
            GROUP BY quantity 
            ORDER BY 
                CASE quantity
                    WHEN 'Bulk (200+)' THEN 1
                    WHEN 'Lots (76-200)' THEN 2
                    WHEN 'Medium (21-75)' THEN 3
                    WHEN 'Few (6-20)' THEN 4
                    WHEN 'Very Few (1-5)' THEN 5
                END
            """
            df = st.session_state.chatbot.execute_sql_query(readiness_query)
            if df is not None and not df.empty:
                st.dataframe(df)

if __name__ == "__main__":
    main()

# ################################
# Gemini Integration Benefits:
# 1. Free tier: 15 requests/min, 1,500/day
# 2. Understands agricultural context
# 3. Generates sophisticated SQL
# 4. Provides agricultural insights
# 5. No complex setup required
# ################################