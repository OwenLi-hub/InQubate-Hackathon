from openai import OpenAI
import random
import universities
import os

client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))  # Initialize OpenAI client




#generate random personal profiles
def generate_personal_info():
    study_levels = ["undergraduate", "graduate"]
    study_level = random.choice(study_levels)
    grade_average = round(random.uniform(70, 100), 2)  # Random grade average between 70 and 100
    ib_points = random.randint(24, 45)  # Random IB points between 24 and 45
    ielts_points = round(random.uniform(5.0, 9.0), 1)  # Random IELTS points between 5.0 and 9.0
    desired_programs = ["Engineering", "Computer Science", "Business", "Medicine", "Law", "Nursing", "Pharmacy", "Agriculture", "Environmental Science", "Arts", "Mathematics"]
    desired_program = random.choice(desired_programs)
    desired_provinces = ["ON", "BC", "QC", "AB", "NS", "MB", "SK", "NB", "NL", "PE", "NT", "NU", "YT"]
    desired_province = random.choice(desired_provinces)

    return {
        "study_level": study_level,
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

    # Ask about study level if not already provided
    if 'study_level' not in info:
        if 'undergraduate' in user_input.lower():
            info['study_level'] = 'undergraduate'
            response_text = "Are you an IB student? (yes or no)"
        elif 'graduate' in user_input.lower():
            info['study_level'] = 'graduate'
            response_text = "Great! What is your grade average?"
        else:
            response_text = "Are you pursuing undergraduate or graduate studies?"
        return response_text

    # Ask about IB status if pursuing undergraduate studies
    if info['study_level'] == 'undergraduate' and 'ib_student' not in info:
        if 'yes' in user_input.lower():
            info['ib_student'] = True
            response_text = "Great! What are your IB points?"
        elif 'no' in user_input.lower():
            info['ib_student'] = False
            response_text = "Great! What is your grade average?"
        else:
            response_text = "Are you an IB student? (yes or no)"
        return response_text

    # Handle specific questions
    if "grade average" in user_input.lower() and 'grade_average' not in info:
        info['grade_average'] = float(user_input.split()[-1])
        response_text = f"My grade average is {info['grade_average']}."
    elif "ib points" in user_input.lower() and 'ib_points' not in info:
        info['ib_points'] = int(user_input.split()[-1])
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






#run testing for chat reponse
def get_chatgpt_response(prompt):
    response = client.Completion.create(
        model="text-davinci-003",
        prompt=prompt,
        max_tokens=150
    )
    return response.choices[0].text.strip()


