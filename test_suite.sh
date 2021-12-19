#!/usr/bin/env bash

REPORTS_FOLDER="/python/reports/"
SECTION_PREFIX="\n#########"


reportvalidation() {
  if [ -z "$1" ]
  then
    echo "OK"
  else
    echo -e "\e[1m\e[91mFAILED\e[21m\e[39m"
    echo "$1"
  fi
}

if [[ $1 == "reports" ]]
then
  MYPY_REPORTS="--junit-xml ${REPORTS_FOLDER}typing.xml"
  PYTEST_REPORTS="--junitxml ${REPORTS_FOLDER}unittesting.xml --cov-report xml:${REPORTS_FOLDER}coverage.xml"
fi

COVERAGE_CONF="--cov-config /home/python/.coverage.conf"
if [ -f ./coverage.conf ];
then
  COVERAGE_CONF="--cov-config ./coverage.conf"
fi

echo -ne "$SECTION_PREFIX RUN TESTS:\n\n"
python -m pytest --rootdir=/python/app -vv --durations=3 --cov ./ --cov-report term-missing $COVERAGE_CONF $PYTEST_REPORTS; STATUS1=$?

echo -ne "$SECTION_PREFIX CHECK TYPING: "
MYPYOUT=`mypy --cache-dir /home/python --no-error-summary . $MYPY_REPORTS`
reportvalidation "$MYPYOUT"; STATUS2=$?

echo -ne "$SECTION_PREFIX CHECK LINTING: "
FLAKE8OUT=`flake8 --append-config /home/python/.flake8 --append-config /python/app/.flake8`
reportvalidation "$FLAKE8OUT"; STATUS3=$?

echo -ne "$SECTION_PREFIX CHECK FORMATTING: "
BLACKOUT=`black --skip-string-normalization --line-length 99 ./ --check 2>&1`; STATUS4=$?
if [[ $BLACKOUT == "All done!"* ]]
then
  echo "OK"
else
  echo -e "\e[1m\e[91mFAILED\e[21m\e[39m"
  echo "$BLACKOUT"
fi

echo

if [[ $1 == "reports" ]]
then
  echo -ne "$SECTION_PREFIX Report files created in $REPORTS_FOLDER\n"
  ls $REPORTS_FOLDER
  echo
fi

TOTAL=$((STATUS1 + STATUS2 + STATUS3 + STATUS4))
exit $TOTAL
