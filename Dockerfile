FROM python:2.7.10
MAINTAINER Kirsten Hunter (khunter@akamai.com)
RUN echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -q curl python-all wget vim python-pip php5 ruby perl5 nodejs npm mongodb
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
