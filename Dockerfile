FROM  ubuntu:xenial
#FROM phusion/baseimage:0.10.1

MAINTAINER Zhanhua Jin "jinzhanhua@gmail.com"

ENV OPENSSL_VER=1.1.0h
ENV STUNNEL_VER=5.48
ENV SQUID_VER=4.1
ENV NETTLE_VER=3.4
ENV TASN1_VER=4.13
ENV P11KIT_VER=0.23.12
ENV GNUTLS_MAJ_VER=3.6
ENV GNUTLS_MIN_VER=3
ENV RADCLI_VER=1.2.10
ENV OCSERV_VER=0.12.1

# install slapd in noninteractive mode
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y supervisor perl g++ m4 iptables dnsmasq wget pkg-config autogen libgmp-dev libffi-dev libunistring-dev libev-dev liblz4-dev libpam-dev libseccomp-dev libreadline-dev libkrb5-dev libwrap0-dev libsystemd-dev libnl-nf-3-dev liboath-dev libgeoip-dev libldap2-dev libsasl2-dev && \
		mkdir /etc/config && \
		mkdir /root/software && \
		cd /root/software && \
		wget https://www.openssl.org/source/openssl-${OPENSSL_VER}.tar.gz && \
		tar zxf openssl-${OPENSSL_VER}.tar.gz && \
		cd openssl-${OPENSSL_VER} && \
		./config -fPIC --prefix=/usr --openssldir=/usr/lib/ssl && \
		make && \
		make install && \
		cd /root/software && \
		wget https://www.stunnel.org/downloads/stunnel-${STUNNEL_VER}.tar.gz && \
		tar zxf stunnel-${STUNNEL_VER}.tar.gz && \
		cd stunnel-${STUNNEL_VER} && \
		./configure --prefix=/usr --sysconfdir=/etc/config --enable-static=yes --enable-shared=no && \
		make && \
		make install && \
		cd /root/software && \
		wget http://www.squid-cache.org/Versions/v4/squid-${SQUID_VER}.tar.gz && \
		tar zxf squid-${SQUID_VER}.tar.gz && \
		cd squid-${SQUID_VER} && \
		./configure --prefix=/usr --exec-prefix=/usr --bindir=/usr/sbin --sbindir=/usr/sbin --sysconfdir=/etc/config --datadir=/etc/data/squid --includedir=/usr/include --libdir=/usr/lib --libexecdir=/usr/lib/squid --localstatedir=/var --sharedstatedir=/usr/com --mandir=/usr/share/man --infodir=/usr/share/info --x-includes=/usr/include --x-libraries=/usr/lib --enable-shared=yes --enable-ssl --enable-static=yes --enable-carp	--enable-storeio=aufs,ufs --enable-removal-policies=heap,lru --disable-icmp --disable-delay-pools --disable-esi --enable-icap-client --enable-useragent-log --enable-referer-log --disable-wccp --enable-wccpv2 --disable-kill-parent-hack --enable-snmp --enable-cachemgr-hostname=localhost --enable-arp-acl --disable-htcp --disable-forw-via-db --enable-follow-x-forwarded-for --enable-auth-basic="DB,fake,getpwnam,LDAP,NCSA,NIS,PAM,POP3,RADIUS,SASL,SMB" --enable-basic-auth-helpers="LDAP,MSNT,NCSA,PAM,SASL,SMB,YP,DB,POP3,getpwnam,squid_radius_auth,multi-domain-NTLM"  --enable-ntlm-auth-helpers="smb_lm," --enable-digest-auth-helpers="ldap,password" --enable-negotiate-auth-helpers="squid_kerb_auth" --enable-cache-digests	--disable-poll --enable-epoll --enable-linux-netfilter --disable-ident-lookups --enable-default-hostsfile=/etc/hosts --with-default-user=proxy --with-large-files  --enable-mit=/usr --with-logdir=/var/log/squid --enable-http-violations --enable-zph-qos --with-filedescriptors=65536 --enable-gnuregex --enable-async-io=64 --with-aufs-threads=64  --with-pthreads --with-aio  --enable-default-err-languages=English --enable-err-languages=English --disable-hostname-checks --enable-underscores && \
		make && \
		make install && \
		apt-get remove -y libnettle6 && \
		cd /root/software && \
    wget http://www.lysator.liu.se/~nisse/archive/nettle-${NETTLE_VER}.tar.gz && \
    tar zxf nettle-${NETTLE_VER}.tar.gz && \
    cd nettle-${NETTLE_VER} && \
    ./configure --prefix=/usr --enable-shared && \
    make && \
    make install  && \
		cd /root/software && \
		wget https://ftp.gnu.org/gnu/libtasn1/libtasn1-${TASN1_VER}.tar.gz && \
		tar zxf libtasn1-${TASN1_VER}.tar.gz && \
    cd libtasn1-${TASN1_VER} && \
    ./configure --prefix=/usr && \
	  make && \
    make install && \
		cd /root/software && \
	  wget https://github.com/p11-glue/p11-kit/releases/download/${P11KIT_VER}/p11-kit-${P11KIT_VER}.tar.gz && \
    tar zxf p11-kit-${P11KIT_VER}.tar.gz && \
    cd p11-kit-${P11KIT_VER} && \
    ./configure --prefix=/usr && \
    make && \
    make install && \
	  cd /root/software && \
		wget https://www.gnupg.org/ftp/gcrypt/gnutls/v${GNUTLS_MAJ_VER}/gnutls-${GNUTLS_MAJ_VER}.${GNUTLS_MIN_VER}.tar.xz && \
		tar xvf gnutls-${GNUTLS_MAJ_VER}.${GNUTLS_MIN_VER}.tar.xz && \
		cd gnutls-${GNUTLS_MAJ_VER}.${GNUTLS_MIN_VER} && \
		./configure --prefix=/usr && \
		make && \
		make install && \
		cd /root/software && \
		wget https://github.com/radcli/radcli/releases/download/1.2.10/radcli-${RADCLI_VER}.tar.gz && \
		tar zxf radcli-${RADCLI_VER}.tar.gz && \
		cd radcli-${RADCLI_VER} && \
		./configure --prefix=/usr && \
		make && \
		make install && \
		cd /root/software && \
		wget ftp://ftp.infradead.org/pub/ocserv/ocserv-${OCSERV_VER}.tar.xz && \
		tar xvf ocserv-${OCSERV_VER}.tar.xz && \
		cd ocserv-${OCSERV_VER} && \
		./configure --prefix=/usr --sysconfdir=/etc/config && \
		make && \
		make install && \
		apt-get remove -y g++ perl m4 wget pkg-config && \
		apt-get autoremove -y && \
		apt-get purge && \
  	rm -rf /var/lib/apt/lists/* && \
		rm -r -f /root/software

# SSL
VOLUME /etc/ssl/private

# CONFIG
VOLUME /etc/config

# DATA
VOLUME /etc/data

# LOG
VOLUME /var/log

# OCSERV PORT
EXPOSE 9000
EXPOSE 9001/udp

# SQUID PORT
EXPOSE 3128

ADD scripts/run.sh /root/run.sh
RUN chmod +x /root/run.sh
CMD /root/run.sh
