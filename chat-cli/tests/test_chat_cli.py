import unittest
import os
import json
import yaml
from unittest.mock import patch
from chat_cli.chat_cli import interact_with_gpt, load_context, setup_logging

class TestChatCLI(unittest.TestCase):

    @patch('chat_cli.chat_cli.openai.Completion.create')
    def test_interact_with_gpt(self, mock_create):
        mock_create.return_value.choices[0].text.strip.return_value = "Test Response"
        context = {"temperature": 0.7, "model": "gpt-4"}
        logger = setup_logging(context)
        response = interact_with_gpt("Test Message", context, logger)
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
