# start from a minimal centos7 image  
FROM centos:7

# prepare the system to install packages

# clear the "nodocs" option so we get man pages for installed packages
RUN yum-config-manager --save --setopt=tsflags=""
# RUN yum update -y 

# install some basics
RUN yum install -y man man-pages less 

# install node 6
RUN curl --silent --location https://rpm.nodesource.com/setup_6.x | bash -
RUN yum install -y nodejs npm

# install debug tools
RUN yum install -y strace

COPY . index.js

EXPOSE 3000

CMD ["node", "index.js"]

