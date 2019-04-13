#!/bin/bash

echo 'using lergo-ri as a base to send emails for production upgrade'
cd lergo-ri
source ~/.nvm/nvm.sh
nvm install
cd ..

export accessKeyId=$accessKeyId
export secretAccessKey=$secretAccessKey
export CI_COMMIT_MESSAGE=$CI_COMMIT_MESSAGE
export CI_TIMESTAMP=${CI_STRING_TIME:-local-build-id}

echo get the build number from production latest
aws s3 cp s3://lergo-backups/builds/production/latest/build.id production-latest.id
export BUILD_NUMBER=`cat production-latest.id`

ls
node send_emails.js