# Ubuntu 14.04.x + Oracle JRE 8
FROM elasticsearch:1.5

MAINTAINER pjpires@gmail.com

# Export HTTP & Transport
EXPOSE 9200 9300

# Install runit
RUN echo "deb http://archive.ubuntu.com/ubuntu trusty main universe" > /etc/apt/sources.list && \
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 40976EAF437D05B5 && \
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32 && \
  apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y runit && \
  apt-get autoremove -y && \
  apt-get autoclean

# Override elasticsearch.yml config, otherwise plug-in install will fail
ADD elasticsearch.yml /elasticsearch/config/elasticsearch.yml

# Install Kubernetes discovery plug-in
RUN /elasticsearch/bin/plugin --install io.fabric8/elasticsearch-cloud-kubernetes/1.1.0 --verbose

ADD run-elasticsearch.sh /etc/service/elasticsearch/run
RUN chmod u+x /etc/service/elasticsearch/run

CMD ["/usr/bin/runsvdir", "-P", "/etc/service"]
