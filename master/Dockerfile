#FROM malet/jenkins-blueocean-docker:latest
FROM jenkinsci/jenkins:2.11

COPY plugins.txt /usr/share/jenkins/ref/
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/ref/plugins.txt
