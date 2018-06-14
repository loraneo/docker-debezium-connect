FROM loraneo/docker-java:8u144a

WORKDIR /opt

ENV KAFKA_HOME /opt/kafka

RUN cd /tmp &&\
	curl -L http://mirror.klaus-uwe.me/apache/kafka/1.0.0/kafka_2.11-1.0.0.tgz -o kafka_2.11-1.0.0.tgz &&\
	tar -xvf kafka_2.11-1.0.0.tgz &&\
	mv kafka_2.11-1.0.0 /opt && \
	ln -s /opt/kafka_2.11-1.0.0 $KAFKA_HOME




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


COPY kafka/connect-distributed.properties $KAFKA_HOME/config/connect-distributed.properties

EXPOSE 8083
CMD $KAFKA_HOME/bin/connect-distributed.sh $KAFKA_HOME/config/connect-distributed.properties

