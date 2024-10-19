#!/bin/bash

# Example startup script: update packages and install some software
sudo apt-get update -y
sudo apt-get install -y htop
sudo apt-get install -y tree

# Add more custom initialization steps here
echo "Hello from the external startup script!"
