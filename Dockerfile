FROM python:3.8.2-alpine

# Install bash
# Create user and home directory
# Create base directory
RUN apk add --no-cache bash build-base libstdc++ &&\
    adduser -u 1000 -S -h /home/python python &&\
    mkdir -p /python && chown python:nogroup /python

# Copy the requirements
COPY requirements.txt /python

RUN pip install -r /python/requirements.txt

# Change users
USER python

# Create base all useful directory
RUN mkdir /python/app /python/logs /python/files /python/static

# Change directory
WORKDIR /python/app

# Install packages in python home directory
ENV PYTHONUSERBASE /home/python
ENV PATH $PATH:/home/python/bin
ENV PYTHONPATH /python/app
