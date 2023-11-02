#!/bin/bash

# Stop the Docker container
docker stop my_container || true
docker rm my_container || true
