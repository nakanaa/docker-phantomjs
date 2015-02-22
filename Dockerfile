# References used:
# https://github.com/phusion/baseimage-docker
# http://phantomjs.org/build.html
FROM phusion/baseimage:0.9.16
MAINTAINER nakanaa

# Set correct environment variables
ENV REFRESHED_AT 20.02.2015
ENV HOME /root
WORKDIR $HOME

RUN \
  apt-get -q -y update && DEBIAN_FRONTEND=noninteractive apt-get -q -y install \
      # Install Wget for download (weird problem with cURL)
	  wget \
      # Install packages required by PhantomJS
      libfontconfig1-dev libfreetype6 && \
  # Clean up APT when done
  apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV PHANTOMJS_VERSION 1.9.8

RUN \
  # Download PhantomJS
  wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-${PHANTOMJS_VERSION}-linux-x86_64.tar.bz2 && \
  # Extract
  tar -xvf *.tar.bz2 && \
  # Copy binary
  cp */bin/phantomjs /usr/local/bin/phantomjs && \
  # Make a symbolic link
  ln -s /usr/local/bin/phantomjs /usr/bin/phantomjs && \
  # Remove downloaded files
  rm -rf *

# Use baseimage-docker's init system
ENTRYPOINT ["/sbin/my_init", "--"]

# Define default command
CMD ["/usr/bin/phantomjs"]