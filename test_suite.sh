#!/usr/bin/env bash

REPORTS_FOLDER="/python/reports/"
SECTION_PREFIX="\n#########"

while getopts ":k:" option; do
  case $option in
    k)
      SPECIFIC_TESTS="-k ${OPTARG}"
  esac
done

checkuser() {
  WHOAMI=`whoami`
  if [ "$WHOAMI" != "python" ]
  then
    echo "ERROR the user in the docker image is $WHOAMI instead or \"python\""
    echo "Use the instruction \"USER python\" in your Dockerfile"
  fi
}


reportvalidation() {
  if [ "$1" -eq 0 ]
  then
    echo "OK"
  else
    echo -e "\e[1m\e[91mFAILED\e[21m\e[39m"
    echo "$2"
  fi
}

if [[ $1 == "reports" ]]
then
  MYPY_REPORTS="--junit-xml ${REPORTS_FOLDER}typing.xml"
  if [ -f ./coverage.conf ];
  then
    covconf="--cov-config ./coverage.conf"
  fi
  PYTEST_REPORTS="--junitxml ${REPORTS_FOLDER}unittesting.xml $covconf --cov-report xml:${REPORTS_FOLDER}coverage.xml"
fi

echo -ne "$SECTION_PREFIX RUN TESTS:\n\n"
python -m pytest -vv --durations=3 --cov ./ --cov-report term-missing $PYTEST_REPORTS $SPECIFIC_TESTS; STATUS1=$?

echo -ne "$SECTION_PREFIX CHECK DOCKER USER IS PYTHON: "
USEROUT=`checkuser`
STATUS2=$?
reportvalidation "$STATUS2" "$USEROUT"

echo -ne "$SECTION_PREFIX CHECK TYPING: "
MYPYOUT=`mypy --cache-dir /home/python --no-error-summary . $MYPY_REPORTS`
STATUS3=$?
reportvalidation "$STATUS3" "$MYPYOUT"

echo -ne "$SECTION_PREFIX CHECK LINTING: "
FLAKE8OUT=`flake8`
STATUS4=$?
reportvalidation "$STATUS4" "$FLAKE8OUT"

echo -ne "$SECTION_PREFIX CHECK FORMATTING: "
BLACKOUT=`black --skip-string-normalization --line-length 99 ./ --check 2>&1`; STATUS5=$?
if [[ $BLACKOUT == "All done!"* ]]
then
  echo "OK"
else
  echo -e "\e[1m\e[91mFAILED\e[21m\e[39m"
  echo "$BLACKOUT"
fi

echo -ne "$SECTION_PREFIX CHECK DOCSTRINGS: "
INTERROGATEOUT=`interrogate`
STATUS5=$?
reportvalidation "$STATUS5" "$INTERROGATEOUT"

if [[ $1 == "reports" ]]
then
  echo -ne "$SECTION_PREFIX Report files created in $REPORTS_FOLDER\n"
  ls $REPORTS_FOLDER
  echo
fi

TOTAL=$((STATUS1 + STATUS2 + STATUS3 + STATUS4 + STATUS5))
exit $TOTAL
