#!/bin/bash
# install project build and release requisites
set -e
rm -rf ./venv/ dist/ build/ *.egg-info
python3 -m venv venv
source venv/bin/activate
python3 -m pip install --upgrade pip setuptools wheel twine sdist bdist_wheel
