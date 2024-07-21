# Chat-CLI

## Version: 0.0.3

A simple command-line interface for interacting with ChatGPT-4.

### Features

- Send messages to ChatGPT-4 and receive responses directly from the command line.
- Use different contexts dynamically via JSON and YAML configuration files.
- Added logging and colorized output for responses.

### Setup

1. Create and activate a virtual environment:

```bash
python -m venv venv
source venv/bin/activate
```

2. Install dependencies:

```bash
make install
```

3. Set up environment variables in .env:

```env
OPENAI_API_KEY=your_openai_api_key
```

### Usage

```bash
python chat_cli.py --context gpt-coder "Your message here"
```

### Tests

Run the tests using:

```bash
make test
```
