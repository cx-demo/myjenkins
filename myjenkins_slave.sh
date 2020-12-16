#!/bin/bash
# Start 'myjenkins-slave' container

CONTAINER_NAME="myjenkins_slave"

if [ $1 = "run" ]
then
	docker run --name $CONTAINER_NAME --detach --init jenkins/inbound-agent -url http://192.168.137.47:6080 -workDir=/home/jenkins/agent ef379c5389313c4d0351a0acb6b81c6979f8fa2eedf2ec1679d3ddb9b83ae4b3 jdk8

	#docker run -p 6080:8080 --name $CONTAINER_NAME -v 
#jenkins_home:/var/jenkins_home -v 
#/downloads:/var/jenkins_home/downloads -d myjenkins:latest

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


