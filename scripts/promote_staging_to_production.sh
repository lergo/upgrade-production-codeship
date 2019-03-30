#!/bin/bash
set -e

# build_id is the build that will be promoted  - it comes from artifacts/latest
aws s3 cp s3://lergo-backups/artifacts/latest/build.id latest-build-number.txt
export build_id=$(cat latest-build-number.txt)
echo check that build number,  $build_id  is an integer
if [[ ! "$build_id" =~ ^[0-9]+$ ]]; then 
  exit 1
fi 

echo promoting artifacts/latest to  build number ${build_id}

echo cd into lergo-ri to install node and npm
cd lergo-ri
source ~/.nvm/nvm.sh
nvm install

echo cd away from package.json to prevent long unecessary npm install
cd ..
npm install

echo install aws-cli
npm install aws-cli

echo copying artifacts/latest to builds/production/latest
aws s3 cp s3://lergo-backups/artifacts/latest/build.id s3://lergo-backups/builds/production/latest/build.id --dryrun
# aws s3 cp s3://lergo-backups/artifacts/latest/install.sh s3://lergo-backups/builds/production/latest/install.sh --dryrun
# aws s3 cp s3://lergo-backups/artifacts/latest/lergo-ri-0.0.0.tgz s3://lergo-backups/builds/production/latest/lergo-ri-0.0.0.tgz --dryrun
# aws s3 cp s3://lergo-backups/artifacts/latest/lergo-ui-0.0.0.tgz s3://lergo-backups/builds/production/latest/lergo-ui-0.0.0.tgz --dryrun

echo copying artifacts/latest to builds/production/ ${build_id} 
aws s3 cp s3://lergo-backups/artifacts/latest/build.id s3://lergo-backups/builds/production/${build_id}/build.id --dryrun
# aws s3 cp s3://lergo-backups/artifacts/latest/install.sh s3://lergo-backups/builds/production/${build_id}/install.sh --dryrun
# aws s3 cp s3://lergo-backups/artifacts/latest/lergo-ri-0.0.0.tgz s3://lergo-backups/builds/production/${build_id}/lergo-ri-0.0.0.tgz --dryrun
# aws s3 cp s3://lergo-backups/artifacts/latest/lergo-ui-0.0.0.tgz s3://lergo-backups/builds/production/${build_id}/lergo-ui-0.0.0.tgz --dryrun

rm -rf latest-build-number.txt

echo promote completed succesfully