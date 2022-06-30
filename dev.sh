# This is a dev file for testing the changes to this repo
docker build . -t satel/python-base:latest
cd tests/
docker build . -t docker-python-base

case $1 in
    run)
        docker run -p 8000:8000 docker-python-base $2
    ;;

    validate)
        docker run docker-python-base validatecodeonce -h
    ;;

    cli)
        docker run -it docker-python-base /bin/bash
    ;;
    
    *)
        echo "Provide parameters 'run', 'validate', or 'cli' when calling e.g. ./dev.sh run"
    ;;
esac
