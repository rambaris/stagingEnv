#!/bin/bash

#Installing Docker
sudo apt-get update
sudo apt install docker.io -y
sudo groupadd docker
sudo usermod -aG docker $USER
sudo systemctl enable docker.service
sudo systemctl enable containerd.service


#Creating container
sudo docker pull rambaris/ngnixserverweb:latest
sudo docker run -d --name webserver -p 80:80 rambaris/ngnixserverweb:latest