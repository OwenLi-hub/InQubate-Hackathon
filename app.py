from flask import Flask, request, jsonify
from chatbot import generate_recommendations, chat_with_gpt, start_new_conversation, chat_with_gpt_for_sop, start_essay_conversation
import json
from flask_cors import CORS


app = Flask(__name__)
CORS(app)


conversations = {}

essay_convo = {}
app.config.from_pyfile('settings.py')


@app.route('/')
def home():
    return "Welcome to the University Recommendation API!"

@app.route('/start', methods=['GET'])
def start_recommendation():
    conversation_id = start_new_conversation()
    conversations[conversation_id] = {"messages": []}
    return jsonify({"message": "Conversation started!", "conversation_id": conversation_id})

@app.route('/start_sop', methods=['GET'])
def start_essay():
    conversation_id = start_essay_conversation()
    essay_convo[conversation_id] = {"messages": []}
    return jsonify({"message": "Conversation started!", "conversation_id": conversation_id})

@app.route('/submit', methods=['POST'])
def submit_information():
    data = request.json
    conversation_id = data.get('conversation_id')
    recommendation = generate_recommendations(conversation_id)
    return jsonify({"recommendation": recommendation})

@app.route('/recommend_universities', methods=['POST'])
def chat():
    data = request.json
    study_level = data.get('study_level')
    budget = data.get('budget')
    desired_program = data.get('program')
    conversation_id = data.get('conversation_id')
    response = chat_with_gpt(study_level=study_level, budget=budget, desired_program=desired_program, conversation_id=conversation_id)
    return jsonify({"response": json.loads(response)})

@app.route('/retrieve', methods=['GET'])
def retrieve_messages():
    conversation_id = request.args.get('conversation_id', default=None, type=int)
    if conversation_id is None or conversation_id not in conversations:
        return jsonify({"error": "Invalid conversation ID"}), 400
    
    conversation_history = conversations[conversation_id]["messages"]
    return jsonify({"conversation": conversation_history, "conversation_id": conversation_id})

@app.route('/generate_sop', methods=['POST'])
def generate_sop():
    data = request.json
    study_level = data.get('study_level')
    budget = data.get('budget')
    desired_program = data.get('program')
    user = data.get('name')
    university = data.get('university')
    conversation_id = data.get('conversation_id')
    response = chat_with_gpt_for_sop(study_level=study_level, budget=budget, desired_program=desired_program, conversation_id=conversation_id, user=user, university=university)
    return jsonify({"response": response})

if __name__ == '__main__':
    app.run(debug=True)