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
