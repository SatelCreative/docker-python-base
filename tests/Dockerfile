ARG IMAGE_VERSION=satel/python-base:latest

# 1. Export the requirements file from poetry
FROM python:3.10.5-slim AS requirements-stage

RUN pip install poetry 
COPY ./pyproject.toml ./poetry.lock* ./

# Generate the requirement file 
ARG DEVFLAG
RUN poetry export -f requirements.txt --output /tmp/requirements.txt $DEVFLAG --without-hashes

# 2. Build the image we want using the requirements file from the first stage
FROM $IMAGE_VERSION

# Copy the files for the server
COPY --from=requirements-stage /tmp/requirements.txt /python/app/requirements.txt
RUN pip install -r /python/app/requirements.txt 
COPY ./ /python/app
