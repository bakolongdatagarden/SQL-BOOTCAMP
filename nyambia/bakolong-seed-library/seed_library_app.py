import streamlit as st
import mysql.connector
from datetime import date
import pandas as pd

# Database connection function
def get_db_connection():
    try:
        connection = mysql.connector.connect(
            host='localhost',  # Change if your MySQL is elsewhere
            port=3306,
            user='root',       # Change to your MySQL username
            password='Bakolong999.',       # Add your MySQL password here
            database='bakolong_seed_library'
        )
        return connection
    except mysql.connector.Error as err:
        st.error(f"Database connection failed: {err}")
        return None

# Function to insert new seed pack
def insert_seed_pack(seed_name, variety, quantity, plant_type, seed_source, date_acquired):
    connection = get_db_connection()
    if connection:
        try:
            cursor = connection.cursor()
            query = """INSERT INTO seed_packs 
                      (seed_name, variety, quantity, plant_type, seed_source, date_acquired) 
                      VALUES (%s, %s, %s, %s, %s, %s)"""
            values = (seed_name, variety, quantity, plant_type, seed_source, date_acquired)
            cursor.execute(query, values)
            connection.commit()
            
            # Get the auto-generated pack_id to return to user
            new_pack_id = cursor.lastrowid
            return True, new_pack_id
        except mysql.connector.Error as err:
            st.error(f"Error inserting data: {err}")
            return False, None
        finally:
            cursor.close()
            connection.close()
    return False, None

# Function to get all seed packs
def get_all_seeds():
    connection = get_db_connection()
    if connection:
        try:
            cursor = connection.cursor()
            cursor.execute("SELECT * FROM seed_packs ORDER BY date_acquired DESC")
            results = cursor.fetchall()
            columns = [desc[0] for desc in cursor.description]
            return pd.DataFrame(results, columns=columns)
        except mysql.connector.Error as err:
            st.error(f"Error fetching data: {err}")
            return pd.DataFrame()
        finally:
            cursor.close()
            connection.close()
    return pd.DataFrame()

# Streamlit App
def main():
    st.title("🌱 Bakolong Seed Library")
    st.subheader("Personal Seed Collection Manager")
    
    # Sidebar for navigation
    st.sidebar.title("Navigation")
    page = st.sidebar.selectbox("Choose a page", ["Add New Seed", "View Collection"])
    
    if page == "Add New Seed":
        st.header("Add New Seed Pack")
        
        # Form for adding new seeds
        with st.form("seed_form"):
            col1, col2 = st.columns(2)
            
            with col1:
                seed_name = st.text_input("Seed Name*", placeholder="e.g., Cherokee Purple Tomato")
                variety = st.text_input("Variety", placeholder="Leave blank if unknown")
                
            with col2:
                quantity = st.selectbox("Quantity*", [
                    "Very Few (1-5)",
                    "Few (6-20)",
                    "Medium (21-75)",
                    "Lots (76-200)",
                    "Bulk (200+)"
                ])
                plant_type = st.selectbox("Plant Type", ["Vegetable", "Herb", "Flower", "Fruit", "Trees & Shrubs", "Other"])
            
            # Source dropdown with custom option
            source_options = ["DPL Seed Library", "Burpee - Purchased", "Seed Savers Exchange", "Other"]
            source_selection = st.selectbox("Source", source_options)
            
            # Show custom text input if "Other" is selected
            if source_selection == "Other":
                custom_source = st.text_input("Custom Source", placeholder="Enter your custom source")
                final_source = custom_source if custom_source else "mystery"
            else:
                final_source = source_selection
            
            date_acquired = st.date_input("Date Acquired*", value=date.today())
            
            submitted = st.form_submit_button("Add Seed Pack")
            
            if submitted:
                if seed_name:  # Basic validation
                    # Use defaults if fields are empty
                    variety_value = variety if variety else "mystery"
                    
                    success, new_pack_id = insert_seed_pack(
                        seed_name, variety_value, quantity, 
                        plant_type, final_source, date_acquired
                    )
                    
                    if success:
                        st.success(f"✅ Added {seed_name} (Pack ID: {new_pack_id}) to your collection!")
                        st.balloons()
                    else:
                        st.error("❌ Failed to add seed pack. Check your database connection.")
                else:
                    st.error("❌ Seed name is required!")
    
    elif page == "View Collection":
        st.header("Your Seed Collection")
        
        # Get and display all seeds
        df = get_all_seeds()
        
        if not df.empty:
            st.write(f"**Total seed packs: {len(df)}**")
            
            # Display filters
            col1, col2, col3 = st.columns(3)
            with col1:
                plant_filter = st.selectbox("Filter by Plant Type", ["All"] + df['plant_type'].unique().tolist())
            with col2:
                quantity_filter = st.selectbox("Filter by Quantity", ["All"] + df['quantity'].unique().tolist())
            with col3:
                source_filter = st.selectbox("Filter by Source", ["All"] + df['seed_source'].unique().tolist())
            
            # Apply filters
            filtered_df = df.copy()
            if plant_filter != "All":
                filtered_df = filtered_df[filtered_df['plant_type'] == plant_filter]
            if quantity_filter != "All":
                filtered_df = filtered_df[filtered_df['quantity'] == quantity_filter]
            if source_filter != "All":
                filtered_df = filtered_df[filtered_df['seed_source'] == source_filter]
            
            # Display the table
            st.dataframe(filtered_df, use_container_width=True)
            
            # Summary statistics
            st.subheader("Collection Summary")
            col1, col2, col3 = st.columns(3)
            with col1:
                st.metric("Total Packs", len(filtered_df))
            with col2:
                st.metric("Plant Types", filtered_df['plant_type'].nunique())
            with col3:
                st.metric("Unique Seeds", filtered_df['seed_name'].nunique())
                
        else:
            st.info("No seed packs in your collection yet. Add some using the 'Add New Seed' page!")

if __name__ == "__main__":
    main()

# ################################
# Updates TO-DO
# 1. Change form entry animation from floating baloons to floating plants?
# 2. Add automatic form refresh functionality after seed pack entry.
# ################################