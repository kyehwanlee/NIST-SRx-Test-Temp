############################################################
# Dockerfile to build NIST-BGP-SRx container images 
# Based on CentOS 7
############################################################
#FROM centos:latest
FROM centos:7
MAINTAINER "Kyehwan Lee".
ENV container docker

RUN sed -i s/mirror.centos.org/vault.centos.org/g /etc/yum.repos.d/*.repo
RUN sed -i s/^#.*baseurl=http/baseurl=http/g /etc/yum.repos.d/*.repo     
RUN sed -i s/^mirrorlist=http/#mirrorlist=http/g /etc/yum.repos.d/*.repo 

RUN yum -y install epel-release 
RUN yum -y install wget libconfig libconfig-devel openssl openssl-devel libcrypto.so.* telnet less gcc
RUN yum -y install uthash-devel net-snmp readline-devel patch git net-snmp-config net-snmp-devel automake rpm-build autoconf libtool
################## BEGIN INSTALLATION ######################

COPY . /root/


# KeyVolt configuration
RUN mkdir -p /usr/opt/bgp-srx-examples/bgpsec-keys/ 
VOLUME ["/usr/opt/bgp-srx-examples/bgpsec-keys/"]


# SRxCryptoAPI configuration

WORKDIR /root/srx-crypto-api
RUN autoreconf -i
RUN ./configure --prefix=/usr CFLAGS="-O0 -g"
RUN make all install && ldconfig


EXPOSE 2605 179 17900 17901 323
CMD ["sleep", "infinity"]
