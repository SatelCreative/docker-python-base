# This is a dev file for testing the changes to this repo
docker build . -t satel/python-base:latest
cd tests/
docker build . -t docker-python-base

if [[ $1 == "run" ]]; then
    docker run -p 8000:8000 docker-python-base
elif [[ $1 == "validate" ]]; then
    docker run docker-python-base validatecodeonce
elif [[ $1 == "cli" ]]; then
    docker run -it docker-python-base /bin/bash
else
    echo "Provide parameters 'run', 'validate', or 'cli' when calling e.g. ./dev.sh run"
fi