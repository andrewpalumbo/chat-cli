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
