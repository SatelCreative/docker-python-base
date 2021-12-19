# FLAKE8: This would trigger an F401 error without the local .flake8
from math import tan

# MYPY: This import triggers a missing import error without the standard config
# file
from fastapi import FastAPI

app = FastAPI()


@app.get('/')
async def root():
    return {'message': 'Hello World'}


def dummy_func():
    # FLAKE8: The following two lines would trigger an E501 flake8 error
    # without the standard config in /home/python
    this_is_a_very_long_variable_name_used_to_test_the_flake8_standard_config = 'ok'
    return this_is_a_very_long_variable_name_used_to_test_the_flake8_standard_config
