#!/bin/bash

docker run --rm -dit --name fugio_php8.4 -p 7272:80 \
-v $PWD/benchmarks:/FUGIO/benchmarks fugio_php8.4:v0.1
