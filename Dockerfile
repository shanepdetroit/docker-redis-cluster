From ubuntu:14.04
MAINTAINER shane-p shanepdetroit@gmail.com
ENV CACHE_FLAG 0
# Install and Upgrade the System
RUN apt-get update
RUN apt-get upgrade -yqq
# Install the dependencies
RUN apt-get install -yqq build-essential gcc g++ openssl wget curl git-core libssl-dev libc6-dev ruby
# Clone the Unstable Version of redis that contains redis-cluster
RUN git clone -b 3.0 https://github.com/antirez/redis.git
# Install Redis and its Tools
WORKDIR /redis
RUN make
RUN gem install redis
# Add the Configuration of the cluster
ADD conf/redis.conf redis.conf
ADD run.sh /run.sh
ENV REDIS_NODE_PORT=7000
# sets ip to eth1 private network ip
ENV REDIS_NODE_IP="$(ifconfig | grep -A 1 'eth0' | tail -1 | cut -d ':' -f 2 | cut -d ' ' -f 1)"
ENTRYPOINT ["/bin/bash","/run.sh"]
