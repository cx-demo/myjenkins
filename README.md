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


## References
Automating Jenkins Docker setup with default admin account [[1]]  
Dockerizing jenkins 2 [[2]]  


[1]:https://technologyconversations.com/2017/06/16/automating-jenkins-docker-setup/ "Automating Jenkins Docker setup with default admin account"
[2]:https://dzone.com/articles/dockerizing-jenkins-2-setup-and-using-it-along-wit "Dockerizing jenkins 2"
[3]:https://getintodevops.com/blog/building-your-first-docker-image-with-jenkins-2-guide-for-developers
