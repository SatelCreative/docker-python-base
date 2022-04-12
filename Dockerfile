ARG IMAGE_VERSION=python:3.10.4-slim
FROM $IMAGE_VERSION

ARG REQUIREMENTS_VERSION=3.10

# Create user and home directory
# Create base directory
RUN apt-get update && apt-get upgrade -y &&\
    useradd -u 1000 -ms /bin/bash -d /home/python python &&\
    mkdir -p /python && chown python:nogroup /python

# Copy the needed files
COPY entrypoint.sh test_suite.sh /python/
COPY requirements_${REQUIREMENTS_VERSION}.txt /python/requirements.txt

ENTRYPOINT ["/python/entrypoint.sh"]

# Add convenient aliases
# Install python packages
RUN echo "#!/bin/bash\n/python/entrypoint.sh startapp" >> /bin/startapp && chmod a+x /bin/startapp &&\
    echo "#!/bin/bash\n/python/entrypoint.sh developapp" >> /bin/developapp && chmod a+x /bin/developapp &&\
    echo "#!/bin/bash\n/python/entrypoint.sh validatecode" >> /bin/validatecode && chmod a+x /bin/validatecode &&\
    echo "#!/bin/bash\n/python/entrypoint.sh validatecodeonce" >> /bin/validatecodeonce && chmod a+x /bin/validatecodeonce &&\
    echo "#!/bin/bash\n/python/entrypoint.sh runtests" >> /bin/runtests && chmod a+x /bin/runtests &&\
    pip install -r /python/requirements.txt

# Change users
USER python

# Create base directories
RUN mkdir /python/app /python/logs /python/files /python/static /python/reports

# Change directory
WORKDIR /python/app

# Install packages in python home directory
ENV PYTHONUSERBASE=/home/python \
    PATH=$PATH:/home/python/bin \
    PYTHONPATH=/python/app

CMD ["startapp"]
