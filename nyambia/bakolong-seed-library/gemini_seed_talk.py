# Version 1.1: Deepseek

import streamlit as st
import mysql.connector
import pandas as pd
from datetime import date
import re
import os
from dotenv import load_dotenv

# Load environment variables from .env
load_dotenv()

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
            except Exception as e:
                st.error(f"Gemini setup error: {e}")
                self.gemini_model = None
    
    # ... [keep all existing database methods unchanged] ...
    
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
        return self.generate_response(prompt)

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
            help="Get free key from https://makersuite.google.com/app/apikey"
        )
        
        if not api_key:
            api_key = os.getenv("API_KEY")
            
        st.divider()
        st.header("🌿 Quick Actions")
        if st.button("View Companion Planting Guide"):
            st.session_state.current_view = "companion_guide"
        if st.button("Return to Main Chat"):
            st.session_state.current_view = "main_chat"
    
    # Initialize assistant
    if 'assistant' not in st.session_state:
        st.session_state.assistant = SeedLibraryAssistant(api_key)
    
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

"""
AttributeError: 'SeedLibraryAssistant' object has no attribute 'text_to_sql'

File "C:\Users\bakol\Documents\SQL-BOOTCAMP\nyambia\bakolong-seed-library\gemini_seed_talk.py", line 223, in <module>
    main()
    ~~~~^^
File "C:\Users\bakol\Documents\SQL-BOOTCAMP\nyambia\bakolong-seed-library\gemini_seed_talk.py", line 176, in main
    sql_query = st.session_state.assistant.text_to_sql(user_question)
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
"""