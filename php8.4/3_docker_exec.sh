#!/bin/bash

docker exec -it $(docker ps -q -f status=running -f name=fugio_php8.4) /bin/bash
