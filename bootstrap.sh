#!/bin/bash

# Update Code Base
# git pull

# Build / Re-Build
# TODO check smarter way to handle updates without wiping the entire build
mkdir -p ./programs/build/
cd programs/build/
rm -rf ./*
cmake ../src
make
cd -

# TODO check smarter way to handle updates without wiping the entire build
mkdir -p ./cbp/build/
cd programs/build/
rm -rf ./*
cmake ../src
make
cd -

