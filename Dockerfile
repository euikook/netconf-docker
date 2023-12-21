FROM euikook/netconf-base:latest

RUN \
	apt-get update && apt-get install -y --no-install-recommends ssh

# Adding netconf user
RUN useradd netconf
RUN mkdir -p /home/netconf/.ssh
RUN echo "netconf:netconf" | chpasswd && adduser netconf sudo


# Clearing and setting authorized ssh keys
RUN \
	echo '' > /home/netconf/.ssh/authorized_keys && \
	ssh-keygen -A && \
	ssh-keygen -t rsa -b 4096 -P '' -f /home/netconf/.ssh/id_rsa && \
	cat /home/netconf/.ssh/id_rsa.pub >> /home/netconf/.ssh/authorized_keys


# Updating shell to bash
RUN sed -i s#/home/netconf:/bin/false#/home/netconf:/bin/bash# /etc/passwd

RUN mkdir /apps && chown -R netconf /apps

RUN echo "root:root" | chpasswd

# sysrepo
RUN \
      cd /netconf && \
      git clone https://github.com/sysrepo/sysrepo.git && cd sysrepo && \
      mkdir build && cd build && \
      cmake -DENABLE_TESTS=OFF -DCMAKE_BUILD_TYPE="Debug" -DCMAKE_INSTALL_PREFIX:PATH=/usr -DSYSREPO_REPOSITORY_PATH:PATH=/etc/sysrepo .. && \
      make -j2 && \
      make install && \
      ldconfig

# netopeer 2
RUN \
      cd /netconf && \
      git clone https://github.com/CESNET/netopeer2.git && cd netopeer2 && \
      mkdir build && cd build && \
      cmake -DCMAKE_BUILD_TYPE:String="Debug" -DCMAKE_INSTALL_PREFIX:PATH=/usr .. && \
      make -j2 && \
      make install

WORKDIR /working

ENV EDITOR vim
EXPOSE 830
