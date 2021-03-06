#!/bin/bash

pip install -r $(rospack find rosbot_voice_control)/../requirements.txt --user

sudo apt install openssl

cd $(rospack find voice_webserver)/src/
wget https://github.com/mozilla/DeepSpeech/releases/download/v0.6.0/deepspeech-0.6.0-models.tar.gz
tar -xzf ./deepspeech-0.6.0-models.tar.gz ; rm -rf deepspeech-0.6.0-models.tar.gz

yarn install 
cd ./cert

hostname=$1
gpu=$2
python $(rospack find voice_webserver)/src/scripts/vw_config.py --update_hostname ${hostname:-"localhost"} --gpu ${gpu:-1} 
    
openssl req -newkey rsa:4096 -x509 -sha256 -days 3650 -nodes -out cert.crt -keyout key.key
cat key.key cert.crt > server.pem
sed -i 's/ENCRYPTED/RSA/g' server.pem

