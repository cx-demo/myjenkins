#!/bin/bash
# build 'myjenkins' container

VERSION=latest
CONTAINER_NAME="myjenkins"

echo $#

if [ $# -ne 0 ]
then
	VERSION=$1
	docker build -t myjenkins:latest -t myjenkins:$VERSION .
else
	echo "./build.sh <version>"
fi


