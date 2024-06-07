from flask import Flask, request, jsonify
from chatbot1 import generate_recommendations, chat_with_gpt, start_new_conversation

app = Flask(__name__)

@app.route('/')
def home():
    return "Welcome to the University Recommendation API!"

@app.route('/start', methods=['GET'])
def start_recommendation():
    conversation_id = start_new_conversation()
    prompt = "Welcome! Please provide your grades, interests, location, and desired program."
    return jsonify({"message": prompt, "conversation_id": conversation_id})

@app.route('/submit', methods=['POST'])
def submit_information():
    data = request.json
    conversation_id = data.get('conversation_id')
    recommendation = generate_recommendations(conversation_id)
    return jsonify({"recommendation": recommendation})

@app.route('/chat', methods=['POST'])
def chat():
    data = request.json
    user_input = data.get('message')
    conversation_id = data.get('conversation_id')
    response = chat_with_gpt(user_input, conversation_id)
    return jsonify({"response": response})

if __name__ == '__main__':
    app.run(debug=True)