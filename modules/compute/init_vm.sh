#!/bin/bash

sudo apt update -y

sudo apt install tree -y

sudo apt install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker

sudo docker pull rocker/geospatial
sudo docker run -d \
    -p 8787:8787 \
    --name rstudio \
    -e ROOT=true \
    -e USER=rstudio \
    -e PASSWORD=$1 \
    rocker/geospatial

sleep 5

sudo docker exec -t rstudio bash -c '

    sudo apt update -y
    sudo apt install tree -y

    mkdir -p ~/.ssh
    echo -e "$2" > ~/.ssh/id_rsa
    chmod 600 ~/.ssh/id_rsa

    touch /.ssh/known_hosts
    ssh-keyscan -H github.com > ~/.ssh/known_hosts
    chmod 600 ~/.ssh/known_hosts

    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_rsa
    git config --global user.email "guilhermeviegas1993@gmail.com"
    git config --global user.name "Gui-go"

    git clone git@github.com:Gui-go/BRdb.git /home/rstudio/BRdb/
    git config --global --add safe.directory /home/rstudio/BRdb/

'

mkdir -p /home/guilhermeviegas1993/clean_data
sudo gsutil -m cp -r gs://"$3"/* /home/guilhermeviegas1993/clean_data/
      
sudo docker cp /home/guilhermeviegas1993/clean_data/. rstudio:/home/rstudio/clean_bucket/
      
echo "VM init finished!"



