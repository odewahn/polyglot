FROM python:2.7.10
MAINTAINER Kirsten Hunter (khunter@akamai.com)
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -q curl python-all wget vim python-pip php5 ruby perl5 nodejs npm 
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes mongodb-server mongodb-dev mongodb
RUN mkdir -p /data/db
run mongod
RUN pip install httpie-edgegrid 
ADD . /opt
WORKDIR /opt/ruby
RUN gem install bundler
RUN bundle install
WORKDIR /opt/python
RUN python /opt/python/tools/setup.py install
WORKDIR /opt/data
RUN mongoimport --collection quotes --file ../data/quoteid.json --type json --jsonArray
WORKDIR /opt/node
RUN npm install
ADD ./MOTD /opt/MOTD
RUN echo "cat /opt/MOTD" >> /root/.bashrc
