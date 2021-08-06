#!/usr/bin/env bash


reportvalidation() {
  if [ -z "$1" ]
  then
    echo "OK"
  else
    echo -e "\e[1m\e[91mFAILED\e[21m\e[39m"
    echo "$1"
  fi
}


python -m pytest -vv --durations=3 --cov ./ --cov-report term-missing; STATUS1=$?

echo -ne "\n######### CHECK TYPING: "
MYPYOUT=`mypy --no-error-summary .`
reportvalidation "$MYPYOUT"; STATUS2=$?

echo -ne "\n######### CHECK LINTING: "
FLAKE8OUT=`flake8`
reportvalidation "$FLAKE8OUT"; STATUS3=$?

echo -ne "\n######### CHECK FORMATTING: "
BLACKOUT=`black --skip-string-normalization ./ --check 2>&1`; STATUS4=$?
if [[ $BLACKOUT == "All done!"* ]]
then
  echo "OK"
else
  echo -e "\e[1m\e[91mFAILED\e[21m\e[39m"
  echo "$BLACKOUT"
fi

echo

TOTAL=$((STATUS1 + STATUS2 + STATUS3 + STATUS4))
exit $TOTAL