#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
processing-java --sketch=$DIR/WeaVER/ --output=/tmp/WeaVERCompile/ --present --force