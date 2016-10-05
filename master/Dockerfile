#FROM malet/jenkins-blueocean-docker:latest
FROM jenkins:2.7.4
# FROM jenkinsci/jenkins:2.20

COPY plugins.txt /usr/share/jenkins/ref/
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/ref/plugins.txt
