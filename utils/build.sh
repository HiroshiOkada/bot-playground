#!/bin/bash

cd `dirname "$0"`
cd ..

docker pull ubuntu:17.04
docker build --tag bot-playground:latest .

