#!/bin/bash

sudo docker run -d -p 9090:9090 --name Prometheus prom/prometheus

sudo docker run -d --name=prometheus1 -p 9090:9090 prom/prometheus