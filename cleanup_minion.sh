#!/bin/bash

instances=`docker ps -qa`
for n in $instances
do
 docker stop $n
 docker rm $n
done
docker rmi `docker images -qa`
instances=`docker -H unix:///var/run/docker-bootstrap.sock ps -qa`
for n in $instances
do
 docker -H unix:///var/run/docker-bootstrap.sock stop $n
 docker -H unix:///var/run/docker-bootstrap.sock rm $n
done
docker -H unix:///var/run/docker-bootstrap.sock rmi `docker -H unix:///var/run/docker-bootstrap.sock images -qa`
service docker stop
killall docker
service docker start

