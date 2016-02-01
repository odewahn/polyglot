FROM python:2.7.10
MAINTAINER Kirsten Hunter (khunter@akamai.com)
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes -q curl python-all wget vim python-pip php5 ruby perl5 nodejs npm 
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes mongodb-server mongodb-dev mongodb
RUN mkdir -p /data/db
RUN /etc/init.d/mongodb start
RUN pip install httpie-edgegrid 
ADD . /opt
WORKDIR /opt/ruby
RUN gem install bundler
RUN bundle install
WORKDIR /opt/python
RUN pip install -r requirements.txt
WORKDIR /opt/node
RUN npm install
WORKDIR /opt/perl
RUN cpan -i Dancer
