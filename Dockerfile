FROM ubuntu:16.04

MAINTAINER DESY, Jan Kotanski <jankotan@gmail.com>

RUN apt-get -qq update && export DEBIAN_FRONTEND=noninteractive && apt-get -qq install -y software-properties-common curl
RUN add-apt-repository "deb http://repos.pni-hdri.de/apt/debian xenial main" -y
RUN curl http://repos.pni-hdri.de/debian_repo.pub.gpg | apt-key add -
RUN apt-get -qq update && export DEBIAN_FRONTEND=noninteractive && apt-get -qq dist-upgrade
RUN apt-get -qq update && export DEBIAN_FRONTEND=noninteractive && apt-get -qq install -y mysql-client mysql-client python-h5py python-sphinx apt-utils debconf-utils net-tools  omniidl libomniorb4-dev libcos4-dev libomnithread3-dev libzmq3-dev
# RUN export DEBIAN_FRONTEND=noninteractive && apt-get -qq install -y  python-pni
RUN useradd -ms /bin/bash tango
RUN  /bin/bash -c 'export DEBIAN_FRONTEND=noninteractive; debconf-set-selections <<< "mysql-server mysql-server/root_password password rootpw"'
RUN  /bin/bash -c 'export DEBIAN_FRONTEND=noninteractive; debconf-set-selections <<< "mysql-server mysql-server/root_password_again password rootpw"'
RUN apt-get -qq update && apt-get -qq install -y mysql-server
RUN  /bin/bash -c 'sleep 10'
RUN /bin/bash -c 'export DEBIAN_FRONTEND=noninteractive; debconf-set-selections <<< "tango-db tango-db/db/app-user string tango"'
RUN /bin/bash -c 'export DEBIAN_FRONTEND=noninteractive; debconf-set-selections <<< "tango-db tango-db/mysql/app-pass	password rootpw"'
RUN /bin/bash -c 'export DEBIAN_FRONTEND=noninteractive; debconf-set-selections <<< "tango-db tango-db/mysql/admin-pass password rootpw"'
RUN /bin/bash -c 'export DEBIAN_FRONTEND=noninteractive; debconf-set-selections <<< "tango-db tango-db/password-confirm password rootpw"'
RUN /bin/bash -c 'export DEBIAN_FRONTEND=noninteractive; debconf-set-selections <<< "tango-db tango-db/app-password-confirm password rootpw"'
RUN /bin/bash -c 'export DEBIAN_FRONTEND=noninteractive; debconf-set-selections <<< "nxsconfigserver-db nxsconfigserver-db/mysql/app-pass password rootpw"'
RUN /bin/bash -c 'export DEBIAN_FRONTEND=noninteractive; debconf-set-selections <<< "nxsconfigserver-db nxsconfigserver-db/mysql/admin-pass password rootpw"'
RUN /bin/bash -c 'export DEBIAN_FRONTEND=noninteractive; debconf-set-selections <<< "nxsconfigserver-db nxsconfigserver-db/app-password-confirm password rootpw"'
RUN /bin/bash -c 'export DEBIAN_FRONTEND=noninteractive; debconf-set-selections <<< "nxsconfigserver-db nxsconfigserver-db/db/app-user string tango"'
RUN apt-get -qq update && apt-get -qq install libtango-tools zlib1g python-tz python-six python-numpy

ENV PKG_CONFIG_PATH=/home/tango/lib/pkgconfig
USER tango
WORKDIR /home/tango

