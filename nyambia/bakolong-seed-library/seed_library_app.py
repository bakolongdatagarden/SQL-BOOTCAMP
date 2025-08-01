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
def insert_seed_pack(pack_id, seed_name, variety, quantity, plant_type, seed_source, date_acquired):
    connection = get_db_connection()
    if connection:
        try:
            cursor = connection.cursor()
            query = """INSERT INTO seed_packs 
                      (pack_id, seed_name, variety, quantity, plant_type, seed_source, date_acquired) 
                      VALUES (%s, %s, %s, %s, %s, %s, %s)"""
            values = (pack_id, seed_name, variety, quantity, plant_type, seed_source, date_acquired)
            cursor.execute(query, values)
            connection.commit()
            return True
        except mysql.connector.Error as err:
            st.error(f"Error inserting data: {err}")
            return False
        finally:
            cursor.close()
            connection.close()
    return False

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
                pack_id = st.number_input("Pack ID", min_value=1, step=1)
                seed_name = st.text_input("Seed Name*", placeholder="e.g., Cherokee Purple Tomato")
                variety = st.text_input("Variety", placeholder="Leave blank if unknown")
                
            with col2:
                quantity = st.selectbox("Quantity*", ["Few", "Medium", "Lots"])
                plant_type = st.selectbox("Plant Type", ["Vegetable", "Herb", "Flower", "Fruit", "Other"])
                seed_source = st.text_input("Source", placeholder="e.g., Oak Lawn Library")
            
            date_acquired = st.date_input("Date Acquired*", value=date.today())
            
            submitted = st.form_submit_button("Add Seed Pack")
            
            if submitted:
                if seed_name:  # Basic validation
                    # Use defaults if fields are empty
                    variety_value = variety if variety else "mystery"
                    source_value = seed_source if seed_source else "mystery"
                    
                    success = insert_seed_pack(
                        pack_id, seed_name, variety_value, quantity, 
                        plant_type, source_value, date_acquired
                    )
                    
                    if success:
                        st.success(f"✅ Added {seed_name} (Pack ID: {pack_id}) to your collection!")
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