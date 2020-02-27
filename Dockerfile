# base image
FROM jenkins/jenkins:lts

# Creator
MAINTAINER Pedric (cxdemosg@gmail.com)

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

