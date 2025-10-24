#!/bin/bash

KAFKA_HEAP_OPTS="-Xms512m -Xmx1g" \
    kafka-consumer-groups.sh \
    --bootstrap-server <broker_host>:<port> \
    --describe --group <consumer_group> \
    --command-config config.properties
