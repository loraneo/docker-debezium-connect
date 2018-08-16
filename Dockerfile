FROM loraneo/docker-java:10.0.2a

WORKDIR /opt
FROM loraneo/docker-java:10.0.2a

ENV KAFKA_HOME /opt/kafka

RUN cd /tmp &&\
	curl -o kafka.tgz -L http://www-eu.apache.org/dist/kafka/2.0.0/kafka_2.12-2.0.0.tgz &&\
	tar -xvf kafka.tgz -C /opt &&\
	ln -s /opt/kafka* $KAFKA_HOME



ENV DEBEZIUM_VERSION=0.7.5 \
    MAVEN_CENTRAL="https://repo1.maven.org/maven2" \
    CONNECTOR=postgres \
    KAFKA_CONNECT_PLUGINS_DIR=$KAFKA_HOME/plugins

RUN mkdir -p $KAFKA_CONNECT_PLUGINS_DIR


RUN set -e &&\
    curl -L -o /tmp/odebezium-connector-plugin.tar.gz \
          $MAVEN_CENTRAL/io/debezium/debezium-connector-$CONNECTOR/$DEBEZIUM_VERSION/debezium-connector-$CONNECTOR-$DEBEZIUM_VERSION-plugin.tar.gz &&\
    tar -xzf /tmp/odebezium-connector-plugin.tar.gz -C $KAFKA_CONNECT_PLUGINS_DIR &&\
    rm -f /tmp/odebezium-connector-plugin.tar.gz;

ENV ELASTIC https://api.hub.confluent.io/api/plugins/confluentinc/kafka-connect-elasticsearch/versions/5.0.0/archive
RUN set -e &&\
    curl -L -o /tmp/kafka-connect-elasticsearch.zip $ELASTIC && \
    unzup /tmp/kafka-connect-elasticsearch.zip -d $KAFKA_CONNECT_PLUGINS_DIR  &&\
    rm -f /tmp/kafka-connect-elasticsearch.zip;
    
COPY kafka/connect-distributed.properties $KAFKA_HOME/config/connect-distributed.properties

EXPOSE 8083
CMD $KAFKA_HOME/bin/connect-distributed.sh $KAFKA_HOME/config/connect-distributed.properties

