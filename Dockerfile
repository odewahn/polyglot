FROM synedra/polyglot:latest

#
# Install some tools specific to training
#

LABEL metadata.launchbot.io="eyJQcm9qZWN0VGFnIjoicG9seWdsb3QiLCJQcm9qZWN0TmFtZSI6IkJlY29taW5nIGEgUG9seWdsb3QiLCJQcm9qZWN0RGVzY3JpcHRpb24iOiJTbGlkZXMgYXJlIGF2YWlsYWJsZSBhdDogaHR0cDovL3d3dy5zbGlkZXNoYXJlLm5ldC9zeW5lZHJhL3BvbHlnbG90LWNvcHkiLCJQcm9qZWN0SG9tZXBhZ2UiOiIiLCJQb3J0TWFwcGluZ3MiOlt7IlBvcnQiOiIzMDAwIiwiRGVzY3JpcHRpb24iOiJCYXNoIHNoZWxsIC8gdGVybWluYWwifSx7IlBvcnQiOiI1MDAwIiwiRGVzY3JpcHRpb24iOiJSZWFkbWUgKyBsaW5rIHRvIGZyb250ZW5kIn0seyJQb3J0IjoiODA4MCIsIkRlc2NyaXB0aW9uIjoiQmFja2VuZCBBUEkgc2VydmVyIn1dfQ=="

# Install a web-based terminal server
RUN wget https://github.com/yudai/gotty/releases/download/v0.0.13/gotty_linux_amd64.tar.gz && \
    tar -zxvf gotty_linux_amd64.tar.gz && \
    mv gotty /usr/local/bin/gotty

# Install a simple server that can publish a directory as a file
RUN wget https://github.com/odewahn/httpServe/releases/download/0.0.2/httpServe-0.0.2-linux-amd64 && \
    mv httpServe-0.0.2-linux-amd64 /usr/local/bin/httpServe

# Set permissions

RUN chmod +x /usr/local/bin/gotty
RUN chmod +x /usr/local/bin/httpServe

# Expose the gotty port and the httpServe ports
EXPOSE 8080
EXPOSE 5000
EXPOSE 3000

WORKDIR /usr/workdir

# Install and run the startup script
ADD run.sh /usr/local/bin/run.sh
RUN chmod +x /usr/local/bin/run.sh
CMD ["/usr/local/bin/run.sh"]


