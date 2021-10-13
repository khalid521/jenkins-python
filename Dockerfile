FROM registry.redhat.io/openshift4/ose-jenkins-agent-base:v4.8.0-202110011559.p0.git.8f554e2.assembly.stream
# FROM registry.ci.openshift.org/ocp/4.10:jenkins-agent-base
ENV __doozer=update BUILD_RELEASE=202110011559.p0.git.8f554e2.assembly.stream BUILD_VERSION=v4.8.0 OS_GIT_MAJOR=4 OS_GIT_MINOR=8 OS_GIT_PATCH=0 OS_GIT_TREE_STATE=clean OS_GIT_VERSION=4.8.0-202110011559.p0.git.8f554e2.assembly.stream SOURCE_GIT_TREE_STATE=clean 
ENV __doozer=merge OS_GIT_COMMIT=8f554e2 OS_GIT_VERSION=4.8.0-202110011559.p0.git.8f554e2.assembly.stream-8f554e2 SOURCE_DATE_EPOCH=1626996972 SOURCE_GIT_COMMIT=8f554e2ad7ab8636cdbf55b5d0bde4577a5c0af6 SOURCE_GIT_TAG=8f554e2 SOURCE_GIT_URL=https://github.com/openshift/jenkins 

# MAINTAINER OpenShift Developer Services <openshift-dev-services+jenkins@redhat.com>

# Labels consumed by Red Hat build service

# ENV NODEJS_VERSION=12 \
#     NPM_CONFIG_PREFIX=$HOME/.npm-global \
#     PATH=$HOME/node_modules/.bin/:$HOME/.npm-global/bin/:$PATH \
#     LANG=en_US.UTF-8 \
#     LC_ALL=en_US.UTF-8

ENV PYTHON_VERSION=3.8 \
    PATH=$HOME/.local/bin/:$PATH \
    PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    PIP_NO_CACHE_DIR=off


COPY configure-agent /usr/local/bin/configure-agent

# Install NodeJS
# RUN INSTALL_PKGS="nodejs nodejs-nodemon make gcc-c++" && \
#     yum module enable -y nodejs:${NODEJS_VERSION} && \
#     yum install -y --setopt=tsflags=nodocs --disableplugin=subscription-manager $INSTALL_PKGS && \
#     rpm -V $INSTALL_PKGS && \
#     yum clean all -y

# install python
RUN INSTALL_PKGS="python38 python38-devel python38-setuptools python38-pip nss_wrapper \
        httpd httpd-devel mod_ssl mod_auth_gssapi mod_ldap \
        mod_session atlas-devel gcc-gfortran libffi-devel libtool-ltdl enchant" && \
    yum -y module enable python38:3.8 httpd:2.4 && \
    yum -y --setopt=tsflags=nodocs install $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    # Remove redhat-logos-httpd (httpd dependency) to keep image size smaller.
    rpm -e --nodeps redhat-logos-httpd && \
    yum -y clean all --enablerepo='*'


RUN chown -R 1001:0 $HOME && \
    chmod -R g+rw $HOME

USER 1001

LABEL \
        com.redhat.component="ose-jenkins-agent-python-container" \
        name="openshift/ose-jenkins-agent-python" \
        architecture="x86_64" \
        io.k8s.display-name="Jenkins Agent Python" \
        io.k8s.description="The jenkins agent python image has the python tools on top of the jenkins agent base image." \
        io.openshift.tags="openshift,jenkins,agent,python" \
        maintainer="aljaghko@aramco.com" \
        License="GPLv2+" \
        vendor="Saudi Aramco" \
        io.openshift.maintainer.product="OpenShift Container Platform" \
        io.openshift.maintainer.component="Jenkins" \
        release="202110011559.p0.git.8f554e2.assembly.stream" \
        io.openshift.build.commit.id="8f554e2ad7ab8636cdbf55b5d0bde4577a5c0af6" \
        io.openshift.build.source-location="https://github.com/openshift/jenkins" \
        io.openshift.build.commit.url="https://github.com/openshift/jenkins/commit/8f554e2ad7ab8636cdbf55b5d0bde4577a5c0af6" \
        version="v4.8.0"