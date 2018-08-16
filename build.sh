#!/bin/bash

mkdir target 
cd target 
git clone https://github.com/confluentinc/kafka-connect-elasticsearch.git
cd kafka-connect-elasticsearch
git checkout v5.0.0
mvn package

docker build -t loraneo/docker-kafka-connect:1.0.0a .