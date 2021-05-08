#!/usr/bin/env bash


loadconfig() {
  if [ -f /run/secrets/config.sh ]; then
    echo "Use configuration from secrets"
    source /run/secrets/config.sh
  elif [ -f ./config.sh ]; then
    echo "Use ./config.sh"
    source ./config.sh
  elif [ -f ./config.sh.example ]; then
    echo "WARNING: Use ./config.sh.example"
    source ./config.sh.example
  else
    echo "ERROR: config.sh not found"
    exit 1
  fi
}


startapp() {
  loadconfig

  appcommand="webapp.main:app"
  if [[ -n ${1} ]]
  then
    appcommand=$1
  fi

  uvicorn --host 0.0.0.0 --port 8000 $appcommand
}


developapp() {
  loadconfig

  appcommand="webapp.main:app"
  if [[ -n ${1} ]]
  then
    appcommand=$1
  fi

  watchmedo auto-restart --patterns="*.py;*.txt;*.yml" --recursive uvicorn -- --host 0.0.0.0 $appcommand
}


validatecode() {
  echo -e "\nREADY TO RUN THE CODE VALIDATION SUITE\nSave a python file to trigger the checks."
  
  source config.sh
  source config_test.sh
  watchmedo shell-command --patterns="*.py;*.txt" --recursive --command="/python/testsuite.sh" --drop .
}


runtests() {
  loadconfig

  if [ -f ./coverage.conf ];
  then
    $covconf="--cov-config ./coverage.conf"
  fi
  python -m pytest -vv --durations=3 --junitxml unittesting.xml --cov=. $covconf\
         --cov-report term-missing --cov-report xml:coverage.xml
}


echo "Command: $1"

case "$1" in
  startapp|developapp|validatecode|runtests)
    # Run the identified command and the provided arguments
    $@
    ;;
  *)
    # Just run any command past to the docker
    echo "EXEC $@"
    exec "$@"
    ;;
esac
