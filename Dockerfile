FROM centos:centos6

MAINTAINER Avdhoot Patankar <avdhoot.patankar@gmail.com>

# Install yum dependencies
RUN yum -y update && \
    yum groupinstall -y development && \
    yum install -y \
    bzip2-devel \
    git \
    hostname \
    openssl \
    openssl-devel \
    sqlite-devel \
    sudo \
    tar \
    wget \
    zlib-dev

# Install python2.7
RUN cd /tmp && \
    wget https://www.python.org/ftp/python/2.7.8/Python-2.7.8.tgz && \
    tar xvfz Python-2.7.8.tgz && \
    cd Python-2.7.8 && \
    ./configure --prefix=/usr/local && \
    make && \
    make altinstall

RUN yum -y update; yum clean all
RUN yum -y install epel-release; yum clean all
RUN yum -y install mongodb-server; yum clean all
RUN mkdir -p /data/db

EXPOSE 27017
ENTRYPOINT ["/usr/bin/mongod"]

 # Download JDK
RUN cd /opt;wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u55-b13/jdk-7u55-linux-x64.tar.gz; pwd

RUN cd /opt;tar xvf jdk-7u55-linux-x64.tar.gz
RUN alternatives --install /usr/bin/java java /opt/jdk1.7.55/bin/java 2


 # Download Apache Tomcat 7
RUN cd /tmp;wget http://apache.mirrors.pair.com/tomcat/tomcat-7/v7.0.73/bin/apache-tomcat-7.0.73.tar.gz

 # untar and move to proper location
RUN cd /tmp;tar xvf apache-tomcat-7.0.73.tar.gz

RUN cd /tmp;mv apache-tomcat-7.0.73 /opt/tomcat7

RUN chmod -R 755 /opt/tomcat7

ENV JAVA_HOME /opt/jdk1.7.0_55

EXPOSE 8080

CMD /opt/tomcat7/bin/catalina.sh run

