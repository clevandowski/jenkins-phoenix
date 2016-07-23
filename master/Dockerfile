#FROM malet/jenkins-blueocean-docker:latest
FROM jenkinsci/jenkins:2.14

COPY plugins.txt /usr/share/jenkins/ref/
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/ref/plugins.txt

# See http://stackoverflow.com/questions/10175812/how-to-create-a-self-signed-certificate-with-openssl
# and See https://issues.jenkins-ci.org/browse/JENKINS-22448 if error "java.io.IOException: DerValue.getBigInteger, not an int 48" occurs
COPY keystore /var/lib/jenkins/keystore
ENV JENKINS_OPTS --httpPort=-1 --httpsPort=8080 --httpsKeyStore=/var/lib/jenkins/keystore --httpsKeyStorePassword=picsou

