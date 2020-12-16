# base image
FROM jenkins/jenkins:lts

# Creator
LABEL maintainer="Pedric (cxdemosg@gmail.com)"

# Change to root user
USER root

# jmeter params
ARG JMETER_VERSION="5.2.1"
ENV JMETER_HOME /opt/apache-jmeter-${JMETER_VERSION}
ENV JMETER_BIN ${JMETER_HOME}/bin
ENV JMETER_DOWNLOAD_URL https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz

# Install jmeter
RUN mkdir -p /tmp/dependencies \ 
	&& wget -O /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz ${JMETER_DOWNLOAD_URL} \ 
	&& mkdir -p /opt \ 
	&& tar -xzf /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz -C /opt \ 
	&& rm -rf /tmp/dependencies 

# Set global path
ENV PATH $PATH:$JMETER_BIN

# Install maven
RUN apt-get update && apt-get install -y maven

# Change to jenkins user
USER jenkins

# Disable Jenkins setup wizard
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

# Add list of plugins
ADD plugins.txt /usr/share/jenkins/ref/

# Install plugins
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

# Adding scripts
COPY groovy/* /usr/share/jenkins/ref/init.groovy.d/
