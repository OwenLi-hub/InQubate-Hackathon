from openai import OpenAI
import random
import os

client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))  # Initialize OpenAI client

# Sample data for universities
universities = [
    {"name": "University of Toronto", "location": "Toronto, ON", "programs": ["Engineering", "Computer Science", "Business"], "ranking": 1, "url": "https://www.utoronto.ca/", "admission_average": "88%", "IB_admission_average": 36, "IELTS_admission_score": 6.5},
    {"name": "University of British Columbia", "location": "Vancouver, BC", "programs": ["Engineering", "Environmental Science", "Arts"], "ranking": 2, "url": "https://www.ubc.ca/", "admission_average": "85%", "IB_admission_average": 34, "IELTS_admission_score": 6.5},
    {"name": "McGill University", "location": "Montreal, QC", "programs": ["Medicine", "Law", "Business"], "ranking": 3, "url": "https://www.mcgill.ca/", "admission_average": "90%", "IB_admission_average": 38, "IELTS_admission_score": 7.0},
    {"name": "University of Alberta", "location": "Edmonton, AB", "programs": ["Nursing", "Pharmacy", "Agriculture"], "ranking": 4, "url": "https://www.ualberta.ca/", "admission_average": "82%", "IB_admission_average": 33, "IELTS_admission_score": 6.5},
    {"name": "University of Waterloo", "location": "Waterloo, ON", "programs": ["Engineering", "Computer Science", "Mathematics"], "ranking": 5, "url": "https://uwaterloo.ca/", "admission_average": "88%", "IB_admission_average": 36, "IELTS_admission_score": 6.5},
]




# Randomly generates information for the applicant
def generate_personal_info():
    grade_average = round(random.uniform(70, 100), 2)  # Random grade average between 70 and 100
    ib_points = random.randint(24, 45)  # Random IB points between 24 and 45
    ielts_points = round(random.uniform(5.0, 9.0), 1)  # Random IELTS points between 5.0 and 9.0
    desired_programs = ["Engineering", "Computer Science", "Business", "Medicine", "Law", "Nursing", "Pharmacy", "Agriculture", "Environmental Science", "Arts", "Mathematics"]
    desired_program = random.choice(desired_programs)
    desired_provinces = ["ON", "BC", "QC", "AB", "NS", "MB", "SK", "NB", "NL", "PE", "NT", "NU", "YT"]
    desired_province = random.choice(desired_provinces)

    return {
        "grade_average": grade_average,
        "ib_points": ib_points,
        "ielts_points": ielts_points,
        "desired_program": desired_program,
        "desired_province": desired_province,
    }

conversations = {}

# Initializes a new conversation
def start_new_conversation():
    conversation_id = len(conversations) + 1
    applicant_info = generate_personal_info()
    conversations[conversation_id] = {
        "info": applicant_info,
        "messages": []
    }
    return conversation_id






# Sends user input to OpenAI's GPT-3.5 and retrieves the response
def chat_with_gpt(user_input, conversation_id):
    conversation = conversations[conversation_id]
    info = conversation['info']
    
    if "grade average" in user_input.lower():
        response_text = f"My grade average is {info['grade_average']}."
    elif "ib points" in user_input.lower():
        response_text = f"I have {info['ib_points']} IB points."
    elif "ielts points" in user_input.lower():
        response_text = f"My IELTS points are {info['ielts_points']}."
    elif "desired program" in user_input.lower():
        response_text = f"My desired program is {info['desired_program']}."
    elif "desired province" in user_input.lower():
        response_text = f"My desired province is {info['desired_province']}."
    else:
        conversation['messages'].append({"role": "user", "content": user_input})
        
        messages = conversation['messages']
        
        response = client.chat.completions.create(
            model="gpt-3.5-turbo",
            messages=messages
        )
        
        response_text = response.choices[0].message.content.strip()
        conversation['messages'].append({"role": "assistant", "content": response_text})
    
    return response_text




# Generates university recommendations based on user input
def generate_recommendations(conversation_id):
    conversation = conversations[conversation_id]['info']
    grade_average = conversation.get('grade_average')
    ib_points = conversation.get('ib_points')
    ielts_points = conversation.get('ielts_points')
    desired_program = conversation.get('desired_program')
    desired_province = conversation.get('desired_province')

    # Filter universities based on the desired program and province
    filtered_universities = [
        uni for uni in universities 
        if desired_program in uni['programs'] 
        and desired_province in uni['location']
        and int(uni['admission_average'][:-1]) <= grade_average  # Compare admission average
        and int(uni['IB_admission_average']) <= ib_points  # Compare IB points
        and float(uni['IELTS_admission_score']) <= ielts_points  # Compare IELTS score
    ]

    # Sort universities based on ranking
    sorted_universities = sorted(filtered_universities, key=lambda x: x['ranking'])

    if sorted_universities:
        recommendations = sorted_universities[:3]  # Get top 3 recommendations
        recommendation_texts = [
            f"We recommend {rec['name']} located in {rec['location']} for the {desired_program} program. You can find more information [here]({rec['url']})."
            for rec in recommendations
        ]
        return "Here are our top recommendations:\n" + "\n\n".join(recommendation_texts)
    else:
         return "Sorry, we couldn't find any universities matching your criteria."



# A simple CLI for testing the chatbot interaction directly from the terminal
if __name__ == "__main__":
    print("Chatbot: Hello, I'm here to help you find the best university for you. What would you like to know?")
    current_conversation_id = start_new_conversation()
    
    while True:
        user_input = input("You: ")
        if user_input.lower() in ["quit", "exit", "bye"]:
            recommendations = generate_recommendations(current_conversation_id)
            print(f"Chatbot: {recommendations}")
            break
        
        response = chat_with_gpt(user_input, current_conversation_id)
        print(f"Chatbot: {response}")







def get_chatgpt_response(prompt):
    response = client.Completion.create(
        model="text-davinci-003",
        prompt=prompt,
        max_tokens=150
    )
    return response.choices[0].text.strip()


