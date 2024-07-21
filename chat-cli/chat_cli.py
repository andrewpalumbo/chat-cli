import os
import argparse
import openai
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

# Check if the environment variable is set
api_key = os.getenv("OPENAI_API_KEY")
if not api_key:
    raise ValueError("The environment variable OPENAI_API_KEY is not set.")

print(f"API Key: {api_key[:5]}...")  # Display only part of the key for verification

# Initialize the OpenAI client
openai.api_key = api_key

def interact_with_gpt(prompt):
    try:
        response = openai.Completion.create(
            engine="gpt-4",  # Use the "gpt-4" model
            prompt=prompt,
            max_tokens=150,
            stop=None,
            n=1,
            temperature=0.7
        )
        return response.choices[0].text.strip()
    except Exception as e:
        print(f"An error occurred: {e}")
        return ""

def main():
    parser = argparse.ArgumentParser(description="Chat with GPT-4 using CLI.")
    parser.add_argument("message", type=str, help="Your message to GPT-4.")
    args = parser.parse_args()

    response = interact_with_gpt(args.message)
    print(f"ChatGPT-4: {response}")

if __name__ == "__main__":
    main()
