#!/bin/bash
# calls `./install.sh`, `./build.sh` and then uploads the result to pypi.org
# expected flow is `develop` -> `approved` -> `master` -> release
set -e

index="test" # todo: vs ..? make a param

pypi_repository="pypi"
pypi_url="https://pypi.org/pypi"
if [ "$index" = "test" ]; then
    pypi_repository="testpypi"
    pypi_url="https://test.pypi.org/pypi"
fi

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
    # failure to read input within timeout causes script to exit with error code 142 rather than wait indefinitely
    timeout=10 # seconds
    read -t $timeout
fi

echo "--- building"
./build.sh
source venv/bin/activate

echo "--- testing build"
python3 -m twine check \
    --strict \
    dist/*

echo "--- checking against remote release"
local_version=$(python3 setup.py --version)
local_version="($local_version)" # hack

package_name=$(python3 setup.py --name)
# "elife-dummy-python-release-project (0.0.1)                      - A small example package"  =>  "(0.0.1)"
remote_version=$(pip search "$package_name" --index "$pypi_url" --isolated | grep "$package_name" | awk '{ print $2 }')
if [ "$local_version" = "$remote_version" ]; then
    echo "Local version $local_version is the same as the remote version $remote_version. Not releasing."
    exit 0 # not a failure case
fi

echo "--- uploading"
python3 -m twine upload \
    --repository "$pypi_repository" \
    --username "__token__" \
    --password "$token" \
    dist/*
