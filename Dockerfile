FROM       ubuntu:14.04
MAINTAINER best "https://github.com/best7766"

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

RUN echo exit 0 > /usr/sbin/policy-rc.d
RUN chmod +x /usr/sbin/policy-rc.d

RUN apt-get update && apt-get upgrade -y
RUN apt-get -y install vim && \
    apt-get -y install wget && \
    apt-get -y install apt-transport-https && \
    apt-get -y install gnupg2 && \
    apt-get -y install net-tools && \
    apt-get -y install libssl-dev && \
    apt-get -y install libcurl4-openssl-dev && \
    apt-get -y install libxml2-dev && \
    apt-get -y install uuid-runtime && \
    apt-get -y install git && \
    apt-get -y install apache2 apache2-doc apache2-utils && \
    apt-get -y install apache2-dev && \
    apt-get -y install tar && \
    apt-get -y install curl && \
    apt-get -y install nano && \
    apt-get -y install gzip && \
    apt-get -y install dialog && \
    apt-get -y install build-essential && \
    apt-get -y install openssh-server && \
    apt-get autoclean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*

RUN echo 'root:root123' |chpasswd

RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN mkdir /root/.ssh

RUN echo "deb http://download.webmin.com/download/repository sarge contrib" >> /etc/apt/sources.list
RUN echo "deb http://webmin.mirror.somersettechsolutions.co.uk/repository sarge contrib" >> /etc/apt/sources.list
RUN wget -q http://www.webmin.com/jcameron-key.asc -O- | sudo apt-key add -
RUN rm /etc/apt/apt.conf.d/docker-gzip-indexes
RUN apt-get -o Acquire::GzipIndexes=false update -y
RUN apt-get install apt-show-versions
RUN apt-get update && apt-get install webmin -y
RUN sed -i 's/10000/80/g' /etc/webmin/miniserv.conf && \
sed -i 's/ssl=1/ssl=0/g' /etc/webmin/miniserv.conf



RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
    
RUN echo "ServerName localhost" >> ../etc/apache2/apache2.conf 
RUN /etc/init.d/apache2 restart
RUN /etc/webmin/start


EXPOSE 22
EXPOSE 80
EXPOSE 443
EXPOSE 10000

CMD    ["/usr/sbin/sshd", "-D"]
