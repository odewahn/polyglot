FROM python:2.7.10
MAINTAINER Kirsten Hunter (khunter@akamai.com)
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -q curl python-all wget vim python-pip php5 ruby perl5 nodejs npm
RUN pip install httpie-edgegrid 
ADD ./examples /opt/examples
ADD ./contrib /opt/contrib
WORKDIR /opt/examples/ruby
RUN gem install bundler
RUN bundle install
WORKDIR /opt/examples/python
RUN python /opt/examples/python/tools/setup.py install
RUN ruby /opt/examples/ruby/
ADD ./MOTD /opt/MOTD
RUN echo "cat /opt/MOTD" >> /root/.bashrc
