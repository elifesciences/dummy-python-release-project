#!/bin/bash
# calls `./install.sh`, `./build.sh` and then uploads the result to pypi.org
# expected flow is `develop` -> `approved` -> `master` -> release
set -e

pypi_repository="testpypi"

# avoid setting this on the command line, it will be visible in your history.
token="$TWINE_PASSWORD"
if [ -z "$token" ]; then
    echo "TWINE_PASSWORD is not set. This is the pypi.org or test.pypi.org API token"
    exit 1
fi

# check we are on the `master` branch.
branch_name=$(git branch --show-current)
if [ "$branch_name" != "master" ]; then
    echo "This is *not* the 'master' branch. Releases should happen from 'master' and not '$branch_name'."
    echo "ctrl-c to quit, any key to continue."
    read
fi

echo "--- building"
./build.sh
source venv/bin/activate

# TODO: check the version to be released with the versions available on the selected pypi repository

# better than nothing.
echo "--- testing build"
python3 -m twine check \
    --strict \
    dist/*

echo "--- uploading"
python3 -m twine upload \
    --repository "$pypi_repository" \
    --username "__token__" \
    --password "$token" \
    dist/*
