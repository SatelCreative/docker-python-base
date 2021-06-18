#!/bin/bash


virtualenv tmpENV
source tmpENV/bin/activate

pip install \
  fastapi              `# Web framework used for all our apps`\
  uvicorn              `# ASGI server`\
  watchdog             `# Used to restart the app in development mode when files are saved`\
  loguru               `# Enjoyable logging in Python`\
  mypy mypy-extensions `# Optional static type checker`\
  pytest pytest-cov    `# Testing suite and utils`\
  pytest-asyncio       `# Add async tests to pytest`\
  flake8               `# Linting`\
  isort                `# Utility to sort and organize imports into sections and types`\
  flake8-isort         `# Plugin to run isort as part of the linting`\
  shortuuid            `# Utility to generate UUIDs`\
  requests httpx       `# HTTP libraries. Requests might be remove in the future`\
  tenacity             `# General-purpose retrying library`\


pip freeze > requirements.txt

deactivate
rm -fr tmpENV
