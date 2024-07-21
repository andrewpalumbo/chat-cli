#!/bin/bash

# Create project directories if they do not exist
mkdir -p chat-cli/context chat-cli/tests

# Create VERSION file if it does not exist
if [ ! -f chat-cli/VERSION ]; then
    echo "0.0.2" > chat-cli/VERSION
fi

# Create README.md file if it does not exist
if [ ! -f chat-cli/README.md ]; then
    cat <<EOL > chat-cli/README.md
# Chat-CLI

## Version: 0.0.2

A simple command-line interface for interacting with ChatGPT-4.

### Features

- Send messages to ChatGPT-4 and receive responses directly from the command line.
- Use different contexts dynamically via JSON and YAML configuration files.

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
python chat_cli.py --context gpt-coder "Your message here"
\`\`\`

### Tests

Run the tests using:

\`\`\`bash
make test
\`\`\`
EOL
fi

# Create setup.py file if it does not exist
if [ ! -f chat-cli/setup.py ]; then
    cat <<EOL > chat-cli/setup.py
from setuptools import setup, find_packages

setup(
    name='chat-cli',
    version='0.0.2',
    packages=find_packages(),
    install_requires=[
        'openai',
        'python-dotenv',
        'pytest',
        'pyyaml',
    ],
)
EOL
fi

# Create requirements.txt file if it does not exist
if [ ! -f chat-cli/requirements.txt ]; then
    cat <<EOL > chat-cli/requirements.txt
openai
python-dotenv
pytest
pyyaml
EOL
fi

# Create Makefile if it does not exist
if [ ! -f chat-cli/Makefile ]; then
    cat <<EOL > chat-cli/Makefile
install:
    python3 -m venv venv
    source venv/bin/activate && pip install -r requirements.txt

test:
    source venv/bin/activate && pytest tests
EOL
fi

# Create .env.example file if it does not exist
if [ ! -f chat-cli/.env.example ]; then
    cat <<EOL > chat-cli/.env.example
# Rename this file to .env and add your OpenAI API key
OPENAI_API_KEY=your_openai_api_key
EOL
fi

# Create context/default.json if it does not exist
if [ ! -f chat-cli/context/default.json ]; then
    cat <<EOL > chat-cli/context/default.json
{
    "api_version": "v1",
    "temperature": 0.7
}
EOL
fi

# Create context/default.yaml if it does not exist
if [ ! -f chat-cli/context/default.yaml ]; then
    cat <<EOL > chat-cli/context/default.yaml
api_version: v1
temperature: 0.7
EOL
fi

# Create context/gpt-coder.json if it does not exist
if [ ! -f chat-cli/context/gpt-coder.json ]; then
    cat <<EOL > chat-cli/context/gpt-coder.json
{
    "api_version": "v1",
    "temperature": 0.5,
    "model": "gpt-3.5-code-davinci-002"
}
EOL
fi

# Create context/gpt-coder.yaml if it does not exist
if [ ! -f chat-cli/context/gpt-coder.yaml ]; then
    cat <<EOL > chat-cli/context/gpt-coder.yaml
api_version: v1
temperature: 0.5
model: gpt-3.5-code-davinci-002
EOL
fi

# Create chat_cli.py file if it does not exist
if [ ! -f chat-cli/chat_cli.py ]; then
    cat <<EOL > chat-cli/chat_cli.py
import os
import argparse
import openai
import json
import yaml
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

def load_context(context_name):
    json_path = f"context/{context_name}.json"
    yaml_path = f"context/{context_name}.yaml"
    
    context = {}
    
    if os.path.exists(json_path):
        with open(json_path, 'r') as json_file:
            context.update(json.load(json_file))
    if os.path.exists(yaml_path):
        with open(yaml_path, 'r') as yaml_file:
            context.update(yaml.safe_load(yaml_file))
    
    return context

def interact_with_gpt(prompt, context):
    model = context.get("model", "gpt-4")
    temperature = context.get("temperature", 0.7)
    
    try:
        response = openai.Completion.create(
            engine=model,
            prompt=prompt,
            max_tokens=150,
            stop=None,
            n=1,
            temperature=temperature
        )
        return response.choices[0].text.strip()
    except Exception as e:
        print(f"An error occurred: {e}")
        return ""

def main():
    parser = argparse.ArgumentParser(description="Chat with GPT-4 using CLI.")
    parser.add_argument("message", type=str, help="Your message to GPT-4.")
    parser.add_argument("--context", type=str, default="default", help="The context configuration to use.")
    args = parser.parse_args()

    context = load_context(args.context)
    response = interact_with_gpt(args.message, context)
    print(f"ChatGPT-4: {response}")

if __name__ == "__main__":
    main()
EOL
fi

# Create test_chat_cli.py file if it does not exist
if [ ! -f chat-cli/tests/test_chat_cli.py ]; then
    cat <<EOL > chat-cli/tests/test_chat_cli.py
import unittest
import os
import json
import yaml
from unittest.mock import patch
from chat_cli import interact_with_gpt, load_context

class TestChatCLI(unittest.TestCase):

    @patch('chat_cli.openai.Completion.create')
    def test_interact_with_gpt(self, mock_create):
        mock_create.return_value.choices[0].text.strip.return_value = "Test Response"
        context = {"temperature": 0.7, "model": "gpt-4"}
        response = interact_with_gpt("Test Message", context)
        self.assertEqual(response, "Test Response")

    def test_load_context_json(self):
        json_context = {
            "api_version": "v1",
            "temperature": 0.7
        }
        os.makedirs("context", exist_ok=True)
        with open("context/default.json", "w") as f:
            json.dump(json_context, f)

        context = load_context("default")
        self.assertEqual(context, json_context)

    def test_load_context_yaml(self):
        yaml_context = {
            "api_version": "v1",
            "temperature": 0.7
        }
        os.makedirs("context", exist_ok=True)
        with open("context/default.yaml", "w") as f:
            yaml.dump(yaml_context, f)

        context = load_context("default")
        self.assertEqual(context, yaml_context)
        
    def tearDown(self):
        if os.path.exists("context/default.json"):
            os.remove("context/default.json")
        if os.path.exists("context/default.yaml"):
            os.remove("context/default.yaml")

if __name__ == '__main__':
    unittest.main()
EOL
fi

echo "Setup complete. Your project structure is initialized to version 0.0.2."





