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
  executeapp "uvicorn --reload --host 0.0.0.0 --port 8000" $1
}


validatecode() {
  help() {
    echo
    echo "Usage: validatecode [-h|k]"
    echo
    echo "Automatically run code validation whenever the code changes."
    echo
    echo "Options:"
    echo "h    Print this help menu."
    echo "k    Invoke Pytest option -k to run specific tests based on a substring match to the test name."
    echo
  }

  while getopts ":h" option; do
    case $option in
      h)
        help
        exit;;
    esac
  done

  echo -e "\nREADY TO RUN THE CODE VALIDATION SUITE\nSave a python file to trigger the checks."
  loadconfig
  watchmedo shell-command --patterns="*.py;*.txt" --recursive --command="/python/test_suite.sh \$@" --drop .
}

validatecodeonce() {
  help() {
    echo
    echo "Usage: validatecodeonce [-h|k]"
    echo
    echo "Trigger a single run of code validation."
    echo
    echo "Options:"
    echo "h    Print this help menu."
    echo "k    Invoke Pytest option -k to run specific tests based on a substring match to the test name."
    echo
  }

  while getopts ":h" option; do
    case $option in
      h)
        help
        exit;;
    esac
  done

  echo -e "\nTriggering single run of code validation."
  loadconfig
  ../test_suite.sh $@ reports
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
  mv *.xml /python/reports/
}


interrogateverbose() {
  echo "Verify docstring coverage"
  interrogate -vv
}


case "$1" in
  startapp|developapp|validatecode|validatecodeonce|runtests|interrogateverbose)
    # Run the identified command and the provided arguments
    $@
    ;;
  *)
    # Just run any command past to the docker
    echo "Execute this in bash: $@"
    exec "$@"
    ;;
esac
