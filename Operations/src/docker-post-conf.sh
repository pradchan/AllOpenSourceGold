#!/bin/bash

sudo curl -fsSL https://get.docker.com/ | sh
sleep 10
sudo usermod -aG docker opc && exit
