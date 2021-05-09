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

executeapp() {
  uvicorncom=$1

  applocation="webapp.main:app"
  if [[ -n ${2} ]]
  then
    applocation=$2
  fi

  loadconfig

  exec $uvicorncom $applocation
}


startapp() {
  echo "Run app in PRODUCTION mode"
  executeapp "uvicorn --host 0.0.0.0 --port 8000" $1
}


developapp() {
  echo "Run app in DEVELOPMENT mode"
  executeapp "watchmedo auto-restart --patterns=\"*.py;*.txt;*.yml\" --recursive uvicorn -- --host 0.0.0.0" $1
}


validatecode() {
  echo -e "\nREADY TO RUN THE CODE VALIDATION SUITE\nSave a python file to trigger the checks."
  
  source config.sh
  source config_test.sh
  watchmedo shell-command --patterns="*.py;*.txt" --recursive --command="/python/testsuite.sh" --drop .
}


runtests() {
  echo "Run pytest and output XML report files"
  loadconfig

  if [ -f ./coverage.conf ];
  then
    $covconf="--cov-config ./coverage.conf"
  fi
  python -m pytest -vv --durations=3 --junitxml unittesting.xml --cov=. $covconf\
         --cov-report term-missing --cov-report xml:coverage.xml
}


case "$1" in
  startapp|developapp|validatecode|runtests)
    # Run the identified command and the provided arguments
    $@
    ;;
  *)
    # Just run any command past to the docker
    echo "Execute this in bash: $@"
    exec "$@"
    ;;
esac