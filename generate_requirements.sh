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
  python-box           `# Make dictionaries nicer to use in tests`\
  flake8               `# Linting`\
  isort                `# Utility to sort and organize imports into sections and types`\
  flake8-isort         `# Plugin to run isort as part of the linting`\
  flake8-quotes        `# Plugin to enforce specific quotes convention, which PEP8 doesn't`\
  black                `# Formatting`\
  shortuuid            `# Utility to generate UUIDs`\
  requests httpx       `# HTTP libraries. Requests might be remove in the future`\
  tenacity             `# General-purpose retrying library`


pip freeze > requirements.txt
