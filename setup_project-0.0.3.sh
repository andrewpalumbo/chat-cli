#!/bin/bash

# Create project directories
mkdir -p chat-cli/context chat-cli/tests

# Create VERSION file
echo "0.0.3" > chat-cli/VERSION

# Create README.md file
cat <<EOL > chat-cli/README.md
# Chat-CLI

## Version: 0.0.3

A simple command-line interface for interacting with ChatGPT-4.

### Features

- Send messages to ChatGPT-4 and receive responses directly from the command line.
- Use different contexts dynamically via JSON and YAML configuration files.
- Added logging and colorized output for responses.

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

# Create setup.py file
cat <<EOL > chat-cli/setup.py
from setuptools import setup, find_packages

setup(
    name='chat-cli',
    version='0.0.3',
    packages=find_packages(),
    install_requires=[
        'openai',
        'python-dotenv',
        'pytest',
        'pyyaml',
        'colorama',
    ],
)
EOL

# Create requirements.txt file
cat <<EOL > chat-cli/requirements.txt
openai
python-dotenv
pytest
pyyaml
colorama
EOL

# Create Makefile
cat <<EOL > chat-cli/Makefile
install:
    python3 -m venv venv
    source venv/bin/activate && pip install -r requirements.txt

test:
    source venv/bin/activate && PYTHONPATH=$(pwd) pytest tests

clean:
    rm -rf venv
    find . -type f -name "*.pyc" -delete
    find . -type d -name "__pycache__" -delete
EOL

# Create .env.example file
cat <<EOL > chat-cli/.env.example
# Rename this file to .env and add your OpenAI API key
OPENAI_API_KEY=your_openai_api_key
EOL

# Create context/default.json
cat <<EOL > chat-cli/context/default.json
{
    "api_version": "v1",
    "temperature": 0.7,
    "log_level": "INFO",
    "log_format": "%(asctime)s - %(name)s - %(levelname)s - %(message)s"
}
EOL

# Create context/default.yaml
cat <<EOL > chat-cli/context/default.yaml
api_version: v1
temperature: 0.7
log_level: INFO
log_format: "%(asctime)s - %(name)s - %(levelname)s - %(message)s"
EOL

# Create context/gpt-coder.json
cat <<EOL > chat-cli/context/gpt-coder.json
{
    "api_version": "v1",
    "temperature": 0.5,
    "model": "gpt-3.5-code-davinci-002",
    "log_level": "INFO",
    "log_format": "%(asctime)s - %(name)s - %(levelname)s - %(message)s"
}
EOL

# Create context/gpt-coder.yaml
cat <<EOL > chat-cli/context/gpt-coder.yaml
api_version: v1
temperature: 0.5
model: gpt-3.5-code-davinci-002
log_level: INFO
log_format: "%(asctime)s - %(name)s - %(levelname)s - %(message)s"
EOL

# Create __init__.py file
touch chat-cli/__init__.py

# Create chat_cli.py file
cat <<EOL > chat-cli/chat_cli.py
import os
import argparse
import openai
import json
import yaml
import logging
from dotenv import load_dotenv
from colorama import Fore, Style, init

# Initialize colorama
init(autoreset=True)

# Load environment variables from .env file
load_dotenv()

# Check if the environment variable is set
api_key = os.getenv("OPENAI_API_KEY")
if not api_key:
    raise ValueError("The environment variable OPENAI_API_KEY is not set.")

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

def setup_logging(context):
    log_level = context.get("log_level", "INFO")
    log_format = context.get("log_format", "%(asctime)s - %(name)s - %(levelname)s - %(message)s")
    logging.basicConfig(level=log_level, format=log_format)
    return logging.getLogger("chat-cli")

def interact_with_gpt(prompt, context, logger):
    model = context.get("model", "gpt-4")
    temperature = context.get("temperature", 0.7)
    
    try:
        logger.info(f"Sending prompt to model {model}")
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
        logger.error(f"An error occurred: {e}")
        return ""

def main():
    parser = argparse.ArgumentParser(description="Chat with GPT-4 using CLI.")
    parser.add_argument("message", type=str, help="Your message to GPT-4.")
    parser.add_argument("--context", type=str, default="default", help="The context configuration to use.")
    parser.add_argument("--model", type=str, help="The model to use, e.g., gpt-4.")
    parser.add_argument("--max_tokens", type=int, help="Maximum number of tokens to generate.")
    parser.add_argument("--temperature", type=float, help="Sampling temperature.")
    parser.add_argument("--output_format", type=str, choices=['plain', 'json'], default="plain", help="Output format.")
    args = parser.parse_args()

    context = load_context(args.context)
    logger = setup_logging(context)
    
    if args.model:
        context['model'] = args.model
    if args.max_tokens:
        context['max_tokens'] = args.max_tokens
    if args.temperature:
        context['temperature'] = args.temperature

    response = interact_with_gpt(args.message, context, logger)

    if args.output_format == "json":
        result = {
            "input": args.message,
            "response": response
        }
        print(json.dumps(result, indent=2))
    else:
        print(Fore.CYAN + f"ChatGPT-4: {response}")

if __name__ == "__main__":
    main()
EOL

# Create test_chat_cli.py file
cat <<EOL > chat-cli/tests/test_chat_cli.py
import unittest
import os
import json
import yaml
from unittest.mock import patch
from chat_cli.chat_cli import interact_with_gpt, load_context

class TestChatCLI(unittest.TestCase):

    @patch('chat_cli.chat_cli.openai.Completion.create')
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

echo "Setup complete. Your project structure is initialized to version 0.0.3."
