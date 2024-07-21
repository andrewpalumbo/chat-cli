#!/bin/bash

# Create project directories
mkdir -p chat-cli/tests

# Create VERSION file
echo "0.0.1" > chat-cli/VERSION

# Create README.md file
cat <<EOL > chat-cli/README.md
# Chat-CLI

## Version: 0.0.1

A simple command-line interface for interacting with ChatGPT-4.

### Features

- Send messages to ChatGPT-4 and receive responses directly from the command line.

### Setup

1. Create and activate a virtual environment:

\`\`\`bash
python -m venv venv
source venv/bin/activate
\`\`\`

2. Install dependencies:

\`\`\`bash
make install
\`\`\`

3. Set up environment variables in .env:

\`\`\`env
OPENAI_API_KEY=your_openai_api_key
\`\`\`

### Usage

\`\`\`bash
python chat_cli.py "Your message here"
\`\`\`

### Tests

Run the tests using:

\`\`\`bash
make test
\`\`\`
EOL

# Create setup.py file
cat <<EOL > chat-cli/setup.py
from setuptools import setup, find_packages

setup(
    name='chat-cli',
    version='0.0.1',
    packages=find_packages(),
    install_requires=[
        'openai',
        'python-dotenv',
        'pytest',
    ],
)
EOL

# Create requirements.txt file
cat <<EOL > chat-cli/requirements.txt
openai
python-dotenv
pytest
EOL

# Create Makefile
cat <<EOL > chat-cli/Makefile
install:
    python3 -m venv venv
    source venv/bin/activate && pip install -r requirements.txt

test:
    source venv/bin/activate && pytest tests
EOL

# Create .env.example file
cat <<EOL > chat-cli/.env.example
# Rename this file to .env and add your OpenAI API key
OPENAI_API_KEY=your_openai_api_key
EOL

# Create chat_cli.py file
cat <<EOL > chat-cli/chat_cli.py
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
EOL

# Create test_chat_cli.py file
cat <<EOL > chat-cli/tests/test_chat_cli.py
import unittest
from unittest.mock import patch
from chat_cli import interact_with_gpt

class TestChatCLI(unittest.TestCase):

    @patch('chat_cli.openai.Completion.create')
    def test_interact_with_gpt(self, mock_create):
        mock_create.return_value.choices[0].text.strip.return_value = "Test Response"
        response = interact_with_gpt("Test Message")
        self.assertEqual(response, "Test Response")

if __name__ == '__main__':
    unittest.main()
EOL

echo "Setup complete. Your project structure is initialized to version 0.0.1."
