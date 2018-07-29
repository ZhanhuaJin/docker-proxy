FROM  ubuntu:xenial
#FROM phusion/baseimage:0.10.1

MAINTAINER Zhanhua Jin "jinzhanhua@gmail.com"

ENV NETTLE_VER=3.4
ENV TASN1_VER=4.13
ENV P11KIT_VER=0.23.12
ENV GNUTLS_MAJ_VER=3.6
ENV GNUTLS_MIN_VER=3
ENV RADCLI_VER=1.2.10
ENV OCSERV_VER=0.12.1

# install slapd in noninteractive mode
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y m4 iptables dnsmasq wget pkg-config autogen libgmp-dev libffi-dev libunistring-dev libev-dev liblz4-dev libpam-dev libseccomp-dev libreadline-dev libkrb5-dev libwrap0-dev libsystemd-dev libnl-nf-3-dev liboath-dev libgeoip-dev && \
		apt-get remove -y libnettle6 && \
		apt-get autoremove -y && \	
		apt-get clean && \
		rm -rf /var/lib/apt/lists/*

# NETTLE
RUN mkdir /root/software && \
		cd /root/software && \
    wget http://www.lysator.liu.se/~nisse/archive/nettle-${NETTLE_VER}.tar.gz && \
    tar zxf nettle-${NETTLE_VER}.tar.gz && \
    cd nettle-${NETTLE_VER} && \
    ./configure --prefix=/usr && \
    make && \
    make install 
# 		chmod -v 755 /usr/lib/lib{hogweed,nettle}.so

# TASN1
RUN cd /root/software && \
		wget https://ftp.gnu.org/gnu/libtasn1/libtasn1-${TASN1_VER}.tar.gz && \
		tar zxf libtasn1-${TASN1_VER}.tar.gz && \
    cd libtasn1-${TASN1_VER} && \
    ./configure --prefix=/usr && \
	  make && \
    make install

# P11-KIT
RUN cd /root/software && \
	  wget https://github.com/p11-glue/p11-kit/releases/download/${P11KIT_VER}/p11-kit-${P11KIT_VER}.tar.gz && \
    tar zxf p11-kit-${P11KIT_VER}.tar.gz && \
    cd p11-kit-${P11KIT_VER} && \
    ./configure --prefix=/usr && \
    make && \
    make install

# GNUTLS 
RUN cd /root/software && \
		wget https://www.gnupg.org/ftp/gcrypt/gnutls/v${GNUTLS_MAJ_VER}/gnutls-${GNUTLS_MAJ_VER}.${GNUTLS_MIN_VER}.tar.xz && \
		tar xvf gnutls-${GNUTLS_MAJ_VER}.${GNUTLS_MIN_VER}.tar.xz && \
		cd gnutls-${GNUTLS_MAJ_VER}.${GNUTLS_MIN_VER} && \
		./configure --prefix=/usr && \
		make && \
		make install

# RADCLI
RUN cd /root/software && \
		wget https://github.com/radcli/radcli/releases/download/1.2.10/radcli-${RADCLI_VER}.tar.gz && \
		tar zxf radcli-${RADCLI_VER}.tar.gz && \
		cd radcli-${RADCLI_VER} && \
		./configure --prefix=/usr && \
		make && \
		make install

# OCSERV
RUN cd /root/software && \
		wget ftp://ftp.infradead.org/pub/ocserv/ocserv-${OCSERV_VER}.tar.xz && \
		tar xvf ocserv-${OCSERV_VER}.tar.xz && \
		cd ocserv-${OCSERV_VER} && \
		./configure --prefix=/usr && \
		make && \
		make install

# CLEAR
RUN apt-get remove -y m4 wget pkg-config && \
		apt-get autoremove -y && \
		apt-get purge && \
		rm -r -f /root/software

# CREATE CONFIG DIRECTORY
RUN mkdir /etc/config		

# SSL
VOLUME /etc/ssl/private

# CONFIG
VOLUME /etc/config

# OCSERV PORT
EXPOSE 9000
EXPOSE 9001/udp


ADD scripts/run.sh /root/run.sh
RUN chmod +x /root/run.sh
CMD /root/run.sh
