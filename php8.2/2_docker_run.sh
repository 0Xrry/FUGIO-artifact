#!/bin/bash

docker run --rm -dit --name fugio_php8.2 -p 7271:80 \
-v $PWD/benchmarks:/FUGIO/benchmarks fugio_php8.2:v0.1
