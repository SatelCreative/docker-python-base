FROM python:3.9.5-slim

# Install bash
# Create user and home directory
# Create base directory
RUN apt-get update -yqq &&\
    apt-get upgrade -yqq &&\
    apt-get install -yqq --no-install-recommends git less openssh-client libopenblas-base build-essential &&\
    apt-get purge --auto-remove -yqq $buildDeps &&\
    apt-get autoremove -yqq --purge &&\
    apt-get clean &&\
    rm -rf \
        /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/* \
        /usr/share/man \
        /usr/share/doc \
        /usr/share/doc-base &&\
    useradd -u 1000 -ms /bin/bash -d /home/python python &&\
    mkdir -p /python && chown python:nogroup /python

# Copy the needed files
COPY entrypoint.sh testsuite.sh requirements.txt /python/

ENTRYPOINT ["/python/entrypoint.sh"]

# Add convenient aliases
RUN echo "alias startapp='/python/entrypoint.sh startapp'" >> ~/.bashrc\
    echo "alias validatecode='/python/entrypoint.sh validatecode'" >> ~/.bashrc\
    echo "alias developapp='/python/entrypoint.sh developapp'" >> ~/.bashrc\
    echo "alias runtests='/python/entrypoint.sh runtests'" >> ~/.bashrc

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
