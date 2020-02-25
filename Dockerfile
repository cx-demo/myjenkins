# base image
FROM jenkins/jenkins:2.204.2

# Creator
MAINTAINER CxDemo SG

# Get rid of admin password setup
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

# Automatically install all plugins
