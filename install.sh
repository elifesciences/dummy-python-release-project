#!/bin/bash
# install project requisites
set -e
rm -rf ./venv/
python3 -m venv venv
source venv/bin/activate
python3 -m pip install --upgrade pip setuptools wheel twine
