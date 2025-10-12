import streamlit as st
import requests
import os

# Configure Streamlit page
st.set_page_config(
    page_title="Flask App Frontend",
    page_icon="🌟",
    layout="wide"
)

# Title and description
st.title("🌟 Flask App Frontend")
st.markdown("---")
st.write("This is a Streamlit frontend that connects to your Flask backend!")

# Flask backend URL - supports both Docker Compose and Kubernetes
FLASK_URL = os.getenv("FLASK_BACKEND_URL", "http://my-testing-app:5000")

# Sidebar
st.sidebar.title("Navigation")
page = st.sidebar.selectbox(
    "Choose a page:",
    ["Home", "Greeting", "API Test"]
)

if page == "Home":
    st.header("Welcome! 👋")
    st.write("This frontend connects to your Flask backend running on port 5000.")
    
    # Test basic connection
    st.subheader("Connection Status")
    try:
        response = requests.get(f"{FLASK_URL}/", timeout=5)
        if response.status_code == 200:
            st.success("✅ Successfully connected to Flask backend!")
            st.write(f"Backend response: {response.text}")
        else:
            st.error(f"❌ Backend returned status code: {response.status_code}")
    except requests.exceptions.RequestException as e:
        st.error(f"❌ Could not connect to Flask backend: {str(e)}")
        st.info("Make sure both services are running with `make start`")

elif page == "Greeting":
    st.header("Personal Greeting 🤝")
    
    # Input field for name
    name = st.text_input(
        "Enter your name:",
        placeholder="Type your name here..."
    )
    
    if name:
        try:
            # Call Flask endpoint
            response = requests.get(f"{FLASK_URL}/MyNameIs/{name}", timeout=5)
            if response.status_code == 200:
                st.success(f"🎉 {response.text}")
            else:
                st.error(f"Error: {response.status_code}")
        except requests.exceptions.RequestException as e:
            st.error(f"Could not connect to backend: {str(e)}")
    else:
        st.info("👆 Enter your name above to get a personalized greeting!")

elif page == "API Test":
    st.header("API Endpoints Test 🔧")
    
    st.subheader("Available Endpoints:")
    
    endpoints = [
        {"method": "GET", "endpoint": "/", "description": "Home page"},
        {"method": "GET", "endpoint": "/MyNameIs/<name>", "description": "Personalized greeting"}
    ]
    
    for ep in endpoints:
        with st.expander(f"{ep['method']} {ep['endpoint']}"):
            st.write(f"**Description:** {ep['description']}")
            
            if ep['endpoint'] == "/":
                if st.button("Test Home Endpoint", key="home"):
                    try:
                        response = requests.get(f"{FLASK_URL}/", timeout=5)
                        st.code(f"Status: {response.status_code}")
                        st.code(f"Response: {response.text}")
                    except Exception as e:
                        st.error(f"Error: {e}")
            
            elif "<name>" in ep['endpoint']:
                test_name = st.text_input("Test with name:", key="test_name", value="World")
                if st.button("Test Greeting Endpoint", key="greeting"):
                    try:
                        response = requests.get(f"{FLASK_URL}/MyNameIs/{test_name}", timeout=5)
                        st.code(f"Status: {response.status_code}")
                        st.code(f"Response: {response.text}")
                    except Exception as e:
                        st.error(f"Error: {e}")

# Footer
st.markdown("---")
st.markdown(
    "**Made with ❤️ using Streamlit and Flask**  \n"
    "Flask Backend: `http://localhost:1000` | Streamlit Frontend: `http://localhost:8501`"
)
