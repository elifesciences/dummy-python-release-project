#!/bin/bash
# cleans and builds project .whl and .tar.gz files
set -e
source venv/bin/activate
rm -rf dist/ build/ *.egg-info
python3 setup.py sdist bdist_wheel
