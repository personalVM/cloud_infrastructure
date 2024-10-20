#!/bin/bash

sudo apt update -y
      
sudo apt install tree -y
      
sudo apt install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker
      
sudo curl -L "https://github.com/docker/compose/releases/download/v2.1.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
      
sudo apt-get install nginx
sudo systemctl enable nginx
sudo systemctl start nginx

sudo docker pull rocker/geospatial

mkdir -p /home/guilhermeviegas1993/data/clean_data/{munic,micro,meso,rgint,rgime,uf}
mkdir -p /home/guilhermeviegas1993/data/curated_data/{munic,micro,meso,rgint,rgime,uf}


