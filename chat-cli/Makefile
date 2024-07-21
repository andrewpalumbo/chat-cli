install:
	python3 -m venv venv
	source venv/bin/activate && pip install -r requirements.txt

test:
	source venv/bin/activate && PYTHONPATH=/home/apalumbo/shared-dev-env/apalumbo/git/chat-cli pytest tests

clean:
	rm -rf venv
	find . -type f -name "*.pyc" -delete
	find . -type d -name "__pycache__" -delete
