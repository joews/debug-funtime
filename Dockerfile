FROM centos:7

# install node 5
RUN curl --silent --location https://rpm.nodesource.com/setup_5.x | bash -
RUN yum install -y nodejs npm

COPY . index.js

EXPOSE 3000

CMD ["node", "index.js"]

