#!/usr/bin/env bash


runpytest() {
  python -m pytest -vv --durations=3
}

reportvalidation() {
  if [ -z "$1" ]
  then
    echo "OK"
  else
    echo -e "\e[1m\e[91mFAILED\e[21m\e[39m"
    echo "$1"
  fi
}


runmypy() {
  echo -ne "\n######### CHECK TYPING: "
  MYPYOUT=`mypy --no-error-summary .`
  reportvalidation "$MYPYOUT"
}

runflake8() {
  echo -ne "\n######### CHECK LINTING: "
  FLAKE8OUT=`flake8`
  reportvalidation "$FLAKE8OUT"
}


echo -e "\nWait 3 seconds for the app to restart"
sleep 3
echo -e "\n######### RUN TESTS ########"
runpytest; runmypy; runflake8
