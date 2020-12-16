#!/bin/bash
# Start 'myjenkins' container

CONTAINER_NAME="myjenkins"

if [ $1 = "run" ]
then
	docker run -p 6080:8080 --name $CONTAINER_NAME -v jenkins_home:/var/jenkins_home -v /downloads:/var/jenkins_home/downloads -v /var/run/docker.sock:/var/run/docker.sock -v $(which docker):$(which docker) -d myjenkins:latest
elif [ $1 = "start" ]
then
	docker start $CONTAINER_NAME
elif [ $1 = "stop" ]
then
	docker stop $CONTAINER_NAME
elif [ $1 = "rm" ]
then
	docker rm $CONTAINER_NAME
else
	echo "./myjenkins.sh <run|start|stop|rm>"
fi


