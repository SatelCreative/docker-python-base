# Satel's Docker Python base

## Purpose


## Commands

The entrypoint of this docker image provides standard commands for our app's docker
image to call with `CMD` in the Dockerfile.
These commands are effectively run as arguments of the entrypoint such as:

```bash
/python/entrypoint.sh startapp
```

The `.bashrc` file contains aliases so that one can also just call `startapp`
from within the docker container.

### startapp

Run the app in production mode.
The command will try to load the `config.sh` from multiple locations:

1. From the docker secrets folder
2. From the current directory, being `/python/app`
3. If the previous locations don't have a `config.sh` file, the `config.sh.example`
   file is loaded from the current directory if it exists as a fallback. This is
   useful for CI/CD environments for which the example values are good enough to
   run the tests

### developapp

Run the app in development mode with `watchmedo` from the `watchdog` python package
such that the app restarts whenever the code changes in `/python/app`.

The configuration file is loaded the same way as in `startapp`.

### validatecode

This command is used during development to automatically run the `pytest` tests,
the `mypy` typing check and the `flake8` linting check whenever the code changes.

The `flake8` linting includes `isort` import module sorting thanks to the `flake8-isort`
plugin.

This code validation command executes the `/python/testsuite.sh` script which can
be overwritten with custom code validation.

### runtests

This command runs only the `pytest` tests for CI/CD purposes. It outputs the tests
and code coverage results in the `/python/app/unittesting.xml` and
`/python/app/coverage.xml` files respectively.
