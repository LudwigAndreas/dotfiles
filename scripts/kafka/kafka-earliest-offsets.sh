#!/bin/bash

KAFKA_HEAP_OPTS="-Xms512m -Xmx1g" \
    kafka-consumer-groups.sh \
    --bootstrap-server <broker_host>:<port> \
    --topic <topic> \
    --group <consumer_group> \
    --reset-offsets --to-earliest \
    --dry-run \
    --command-config config.properties
