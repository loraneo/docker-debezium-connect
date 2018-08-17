FROM loraneo/docker-java:10.0.2a

WORKDIR /opt

ENV KAFKA_HOME /opt/confluent

RUN curl -O http://packages.confluent.io/archive/4.1/confluent-4.1.0-2.11.tar.gz && \
      tar -xvpf confluent-4.1.0-2.11.tar.gz -C /opt &&\
      mv confluent-4.1.0 confluent
      
COPY kafka/connect-distributed.properties $KAFKA_HOME/config/connect-distributed.properties

RUN mkdir -p /opt/kafka/plugins &&\
	cp -r /opt/confluent/share/java/kafka-connect-elasticsearch/ /opt/confluent/share/java/kafka/
	
EXPOSE 8083
CMD $KAFKA_HOME/bin/connect-distributed $KAFKA_HOME/config/connect-distributed.properties

