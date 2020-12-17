# Customizing Checkmarx Jenkins container
* Author: Pedric Kng
* Updated: 25 Feb 2020

Guide on installing Jenkins container with Checkmarx plugin
See https://github.com/cx-demo/myjenkins

***
## Overview

## Installation
1. Create [Dockerfile](Dockerfile)

``` groovy
# base image
FROM jenkins/jenkins:lts

# Creator
LABEL maintainer="Pedric (cxdemosg@gmail.com)"

# Install maven in container
USER root
RUN apt-get update && apt-get install -y maven
USER jenkins

# Disable Jenkins setup wizard
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

# Add list of plugins
ADD plugins.txt /usr/share/jenkins/ref/

# Install plugins
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

# Adding scripts
COPY groovy/* /usr/share/jenkins/ref/init.groovy.d/

```

2. Build docker image

```bash
docker build -t myjenkins:latest -t myjenkins:<$VERSION> .
```

Helper sh script is available [build.sh](build.sh)
```bash
# Note that the default image name is 'myjenkins'
./build.sh <image version>
```

3. Run myjenkins container

```bash
docker run -p 6080:8080 --name $CONTAINER_NAME -v jenkins_home:/var/jenkins_home -v /downloads:/var/jenkins_home/downloads -d myjenkins:latest
```

## Adding docker execution environment for Jenkins

1. Including docker ce, docker ce-cli and containerd to [Dockerfile](Dockerfile)

```groovy

# install docker, docker-compose, docker-machine
# see: https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/
# see: https://docs.docker.com/engine/installation/linux/linux-postinstall/
# see: https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/

# prerequisites for docker
RUN apt-get update \
    && apt-get -y install \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg-agent \
        software-properties-common

# docker
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
    && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable" \
    && apt-get update \
    && apt-get -y install docker-ce docker-ce-cli containerd.io

# docker-compose
RUN curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose

# give jenkins docker rights
RUN usermod -aG docker jenkins

```

2. Give docker cli(Jenkins Container) privileges to docker.sock (host)

Quick means is to grant all permissions, but it is recommended for production.
```
sudo chmod 777 /var/run/docker.sock
```
For a more secure setup, refer to [[4]]


3. Build docker image as described previously.

4. Execute jenkins docker with docker.sock bind

```bash
# Note how docker.sock is bind between the host and jenkins container
docker run -p 6080:8080 --name $CONTAINER_NAME -v jenkins_home:/var/jenkins_home -v /downloads:/var/jenkins_home/downloads -v /var/run/docker.sock:/var/run/docker.sock -v ${which docker}:${which docker} -d myjenkins:latest
```


## References
Automating Jenkins Docker setup with default admin account [[1]]  
Dockerizing jenkins 2 [[2]]  
Docker inside Docker for Jenkins [[4]]  

[1]:https://technologyconversations.com/2017/06/16/automating-jenkins-docker-setup/ "Automating Jenkins Docker setup with default admin account"
[2]:https://dzone.com/articles/dockerizing-jenkins-2-setup-and-using-it-along-wit "Dockerizing jenkins 2"
[3]:https://getintodevops.com/blog/building-your-first-docker-image-with-jenkins-2-guide-for-developers
[4]:https://itnext.io/docker-inside-docker-for-jenkins-d906b7b5f527 "Docker inside Docker for Jenkins"

