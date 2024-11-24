#!/bin/bash

sudo sysctl -w net.inet.ip.ttl=65
networksetup -setv6off Wi-Fi
