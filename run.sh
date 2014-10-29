#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
processing-java --sketch=$DIR/WeatherWatch/ --output=/tmp/WeatherWatchCompile/ --run --force