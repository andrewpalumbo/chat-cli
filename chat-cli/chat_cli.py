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
