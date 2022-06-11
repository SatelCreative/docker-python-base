
# DEV image
FROM satel/python-base:202206-rc1 AS webapp_dev

# Copy the files for the server
COPY ./ /python/app

RUN pip install poetry 

COPY ./pyproject.toml ./poetry.lock* /python/app/

# Generate the requirment file 
RUN poetry export -f requirements.txt --output /python/app/requirements.txt --dev --without-hashes

RUN pip install -r /python/app/requirements.txt


# PRD image 
FROM satel/python-base:202206-rc1 AS webapp_prd
 
COPY ./ /python/app

RUN pip install poetry 

COPY ./pyproject.toml ./poetry.lock* /python/app/

RUN poetry export -f requirements.txt --output /python/app/requirements.txt --without-hashes

RUN pip install -r /python/app/requirements.txt

USER root

RUN apt-get install -y curl
