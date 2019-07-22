#!/usr/bin/env bash

docker run -it --rm --name requests_logger \
    -p 4567:4567 \
    -v "$PWD":/usr/src \
    requests_logger:latest
