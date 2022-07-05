ARG IMAGE_VERSION=satel/python-base:latest

# 1. Export the requirements file from poetry
FROM $IMAGE_VERSION AS requirements-stage

RUN pip install poetry 
COPY ./pyproject.toml ./poetry.lock* /python/app/

# Generate the requirement file 
ARG DEVFLAG
RUN poetry export -f requirements.txt --output /python/app/requirements.txt $DEVFLAG --without-hashes

# 2. Build the image we want using the requirements file from the first stage
FROM $IMAGE_VERSION

# Copy the files for the server
COPY --from=requirements-stage /python/app/requirements.txt /app/requirements.txt
RUN pip install -r /app/requirements.txt 
COPY ./ /python/app
