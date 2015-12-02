#!/bin/bash

# Update Code Base
# git pull

# Build / Re-Build
# TODO check smarter way to handle updates without wiping the entire build
mkdir -p ./processing/programs/build/
cd processing/programs/build/
cmake ../src
make
cd -

# TODO check smarter way to handle updates without wiping the entire build
mkdir -p ./processing/cbp/build/
cd processing/cbp/build/
cmake ../src
make
cd -

