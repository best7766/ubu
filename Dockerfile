FROM       ubuntu:14.04
MAINTAINER Aleksandar Diklic "https://github.com/rastasheep"

WORKDIR /
COPY webmin-check.sh .
RUN apt-get update && apt-get upgrade -y
RUN apt-get install apt-transport-https wget gnupg2 -y
RUN apt-get install -y tar git curl nano wget gzip dialog net-tools build-essential apache2 apache2-doc apache2-utils libapache2-mod-perl2 libapache2-mod-python libapache2-mod-php5 php5 php-pear php5-xcache

RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd

RUN echo 'root:root123' |chpasswd

RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

RUN mkdir /root/.ssh


RUN echo "deb https://download.webmin.com/download/repository sarge contrib" >> /etc/apt/sources.list && \
cd /root && \
wget http://www.webmin.com/jcameron-key.asc && \
apt-key add jcameron-key.asc 

RUN rm /etc/apt/apt.conf.d/docker-gzip-indexes && \
apt-get purge apt-show-versions -y && \
rm /var/lib/apt/lists/*lz4 && \
apt-get -o Acquire::GzipIndexes=false update -y

RUN apt-get update && apt-get install webmin -y

RUN sed -i 's/10000/80/g' /etc/webmin/miniserv.conf && \
sed -i 's/ssl=1/ssl=0/g' /etc/webmin/miniserv.conf


RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN /etc/init.d/apache2 restart
RUN /etc/webmin/start


EXPOSE 22
EXPOSE 80
EXPOSE 10000

CMD    ["/usr/sbin/sshd", "-D"]
