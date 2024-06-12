# Import necessary modules
from openai import OpenAI
import random
import universities  # Assuming this is a module containing university data
import os

# Initialize OpenAI client
client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))


# Generate random personal profiles
def generate_personal_info(study_level, desired_program, budget):
    # study_levels = ["undergraduate", "graduate"]
    # study_level = random.choice(study_levels)
    grade_average = round(random.uniform(60, 100), 2)  # Random grade average between 70 and 100
    ib_points = random.randint(24, 45)  # Random IB points between 24 and 45
    ielts_points = round(random.uniform(5.0, 9.0), 1)  # Random IELTS points between 5.0 and 9.0
    # desired_programs = ["Engineering", "Computer Science", "Business", "Medicine", "Law", "Nursing", "Pharmacy", "Agriculture", "Environmental Science", "Arts", "Mathematics"]
    # desired_program = random.choice(desired_programs)
    desired_provinces = ["ON", "BC", "QC", "AB", "NS", "MB", "SK", "NB", "NL", "PE", "NT", "NU", "YT"]
    # desired_province = random.choice(desired_provinces)

    return {
        "study_level": study_level,
        "grade_average": grade_average,
        "ib_points": ib_points,
        "ielts_points": ielts_points,
        "desired_program": desired_program,
        "desired_provinces": desired_provinces,
        "budget": budget
    }

# Create a dictionary to store conversations
conversations = {0: {}}
essay_convo = {0: {}}



# Initializes a new conversation
def start_new_conversation():
    conversation_id = len(conversations)
    initial_prompt = "I need you to return a list of schools for me. I will give you my info and you will give me the schools in a format I will specify. Ready?"
    
    conversations[int(conversation_id)] = {
        "messages": [{"role": "system", "content": initial_prompt}]
    }
    print(f'CONVO: {conversations}')
    return conversation_id

# Initializes a new conversation
def start_essay_conversation():
    conversation_id = len(essay_convo)
    initial_prompt = "I need you to generate an SOP. I would give you some example details to test your capabilites. Ready?"
    
    essay_convo[int(conversation_id)] = {
        "messages": [{"role": "system", "content": initial_prompt}]
    }
    print(f'CONVO: {conversations}')
    return conversation_id


# Sends user input to OpenAI's GPT-3.5 and retrieves the response
def chat_with_gpt(study_level, budget, desired_program, conversation_id):
    print(f'CONVO2: {conversations}')
    conversation = conversations[int(conversation_id)]
    applicant_info = generate_personal_info(study_level=study_level, budget=budget, desired_program=desired_program)

    conversation['messages'].append({"role": "user", "content": f"""
Recommend Universities in Canada for me. Here is my info: {applicant_info}

Answer me the list of schools and their details in a json format. Don't say any other thing. Include Queen's University and UofT

Use the fields in this example response:
{{
        "university": "University of Ottawa",
        "program": "Bachelor of Computer Science",
        "province": "ON",
        "requirements": {{
            "grade_average": "70",
            "ib_points": "30",
            "ielts_points": "6.5"
        }},
        "tuition_fees": "$35,000",
        "website": "https://www.uottawa.ca"
    }},
"""})

    
    messages = conversation['messages']
    
    response = client.chat.completions.create(
        model="gpt-3.5-turbo",
        messages=messages
    )
    
    response_text = response.choices[0].message.content
    conversation['messages'].append({"role": "assistant", "content": response_text})
    
    return response_text


# Sends user input to OpenAI's GPT-3.5 and retrieves the response
def chat_with_gpt_for_sop(study_level, budget, desired_program, conversation_id, user, university):
    print(f'CONVO2: {essay_convo}')
    conversation = essay_convo[int(conversation_id)]
    applicant_info = generate_personal_info(study_level=study_level, budget=budget, desired_program=desired_program)

    conversation['messages'].append({"role": "user", "content": f"""
I would like to generate an example Statement of Purpose (SOP) for a application in {desired_program} at {university}. The SOP should include the following sections:

Introduction: Briefly introduce the applicant and state the purpose of the SOP.
Academic Background: Detail the applicant's academic history, highlighting relevant coursework and achievements.
Professional Experience: Describe any relevant work or research experience, including projects or positions held.
Research Interests: Explain the applicant's research interests and how they align with the program.
Career Goals: Outline the applicant's career aspirations and how the program will help achieve these goals.
Conclusion: Summarize the key points and express enthusiasm for the program.
Make the SOP approximately 500-700 words long. The tone should be formal and professional.
Just generate the essay. Don't say any other thing like here is an example sop blah blah blah. 
info for example user: {applicant_info}
"""})

    
    messages = conversation['messages']
    
    response = client.chat.completions.create(
        model="gpt-3.5-turbo",
        messages=messages
    )
    
    response_text = response.choices[0].message.content
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






# Function to get GPT-3.5 response
def get_chatgpt_response(prompt):
    response = client.Completion.create(
        model="text-davinci-003",
        prompt=prompt,
        max_tokens=150
    )
    return response.choices






