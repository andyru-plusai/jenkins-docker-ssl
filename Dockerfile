FROM jenkins/jenkins:lts

USER root

# Install necessary packages
RUN apt-get update && \
    apt-get install -y curl openssl apt-transport-https ca-certificates ca-certificates-java software-properties-common && \
    update-ca-certificates

# Install Docker CLI
RUN curl -fsSL https://get.docker.com | bash -

# Install Docker Compose
RUN curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

USER jenkins

ARG BUILD_DATE="2024-11-22T01:28:05Z"
ARG SSL_PASS=changeit
ENV JENKINS_HOME /var/jenkins_home
ENV CERT_FOLDER "$JENKINS_HOME/.ssl"
ENV ROOT_CA ""
ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000

# SSL Setup
ENV JENKINS_OPTS --httpPort=-1 --httpsPort=8443 --httpsKeyStore="$CERT_FOLDER/jenkins.jks" --httpsKeyStorePassword=${SSL_PASS}
EXPOSE 8443

ENTRYPOINT ["/usr/bin/tini", "--"]