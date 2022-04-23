#!/bin/bash


pip install \
  fastapi              `# Web framework used for all our apps`\
  uvicorn              `# ASGI server`\
  watchdog pyyaml argh `# Used to restart the app in development mode when files are saved`\
  loguru               `# Enjoyable logging in Python`\
  mypy mypy-extensions `# Optional static type checker`\
  pytest pytest-cov    `# Testing suite and utils`\
  pytest-mock          `# Provide mocker fixture`\
  pytest-asyncio       `# Add async tests to pytest`\
  nest-asyncio         `# For the asyncio loop`\
  flake8               `# Linting`\
  isort                `# Utility to sort and organize imports into sections and types`\
  flake8-isort         `# Plugin to run isort as part of the linting`\
  flake8-quotes        `# Plugin to enforce specific quotes convention, which PEP8 doesn't`\
  flake8-print         `# Plugin to prevent the use of print statements`\
  black                `# Formatting`\
  interrogate          `# Checks code base for missing docstrings`\


pip freeze > requirements.txt
