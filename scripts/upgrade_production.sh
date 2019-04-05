#!/bin/bash
set -e
echo 'access production to perform upgrade'

pushd lergo-ri
    source ~/.nvm/nvm.sh
    nvm install
    npm install
popd

cd lergo-ri
echo 'pwd:'
pwd
echo 'TESTME_KEY' $TESTME_KEY

echo 'creating file conf/dev/newproduction.pem'
mkdir conf/dev && touch conf/dev/newproduction.pem

source build/decrypt_newproduction_pem.sh

mkdir ~/.ssh && touch ~/.ssh/known_hosts
ssh-keyscan -H 52.16.85.48 >> ~/.ssh/known_hosts
export KEY_FILE=conf/dev/newproduction.pem

echo 'accessing production'
chmod 600 $KEY_FILE
ssh -i $KEY_FILE ubuntu@52.16.85.48 << EOF
echo 'inside production'
ls
sudo service lergo upgrade && sudo service lergo stop && sudo service lergo start
sudo service lergo status
exit
EOF
