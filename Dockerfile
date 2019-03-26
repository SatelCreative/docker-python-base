FROM python:3.7-alpine

# Install bash
# Create user and home directory
# Create base directory
RUN apk add --no-cache bash build-base libstdc++ &&\
    adduser -u 1000 -S -h /home/python python &&\
    mkdir -p /python && chown python:nogroup /python

# Change users
USER python

# Create base app directory
RUN mkdir /python/app

# Change directory
WORKDIR /python/app

# Install packages in python home directory
ENV PYTHONUSERBASE /home/python
ENV PATH $PATH:/home/python/bin
ENV PYTHONPATH /python/app
