FROM evarga/jenkins-slave:latest

ARG MAVEN_VERSION=3.5.2
ENV MAVEN_OPTS="-Djavax.net.ssl.trustStore=/etc/ssl/certs/java/cacerts"

RUN \
  apt-get update \
  && apt-get install -y git ca-certificates-java openjdk-8-jdk \
  && apt-get autoremove \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/* \
  && rm -f /var/cache/apt/*.bin

ADD http://apache.crihan.fr/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz /var/lib/

RUN \
  cd /var/lib \
  && tar xvf apache-maven-${MAVEN_VERSION}-bin.tar.gz \
  && ln -s /var/lib/apache-maven-${MAVEN_VERSION}/bin/mvn /usr/bin/mvn \
  && rm -rf /var/lib/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
  && update-ca-certificates -f
