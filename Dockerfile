FROM ubuntu:latest
MAINTAINER Glendon Leitao <glendonml@gmail.com>

# Installation:
# Import MongoDB public GPG key AND create a MongoDB list file
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
RUN echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.2.list


# Update apt-get sources AND install MongoDB
RUN apt-get update && apt-get install -y --allow-unauthenticated mongodb-org
RUN mkdir -p /data/db

RUN apt-get install -y default-jdk
RUN apt-get install -y curl
RUN apt-get install unzip

RUN apt-get install -y git
RUN cd /var && git clone https://f98efc238c8d6482cdefaa65000eef5f84eaf1c6@github.com/glendon/vivareal.git

RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN curl -s get.sdkman.io | bash
RUN bash -c "source $HOME/.sdkman/bin/sdkman-init.sh && sdk install grails && grails -version && cd /var/vivareal && grails -version"

RUN apt-get install -y gradle
RUN cd /var/vivareal && gradle build --refresh-dependencies -x integrationTest

RUN mkdir -p /var/init/vivareal

RUN mkdir -p /var/vivarealconfig
ADD vivareal.sh /var/vivarealconfig/init
RUN chmod 777 /var/vivarealconfig/init

WORKDIR /var/vivareal

EXPOSE 80
ENTRYPOINT /var/vivarealconfig/init