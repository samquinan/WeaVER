#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
processing-java --force --sketch=$DIR/WeaVER/ --output=/tmp/WeaVERCompile/ --run 