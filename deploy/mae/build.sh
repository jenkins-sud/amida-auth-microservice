#!/bin/sh

printf "\n\n\n\n**** RUNNING build.sh ********************\n\n"

# Set DTR for Docker - Perform against ALL Dockerfiles in your project
/usr/bin/perl -i -pe "s|%%DTR_PREFIX%%|$DTR_PREFIX|" Dockerfile || { echo "FATAL: Could not set DTR Prefix"; exit 1; }
/usr/bin/perl -i -pe "s|%%DTR_ORG%%|$DTR_ORG|" Dockerfile || { echo "FATAL: Could not set DTR Ogranization'"; exit 1; }

# Dependency Check
printf "\n\n**** Mandatory: Dependency Checks ********************\n"

# PATH=/usr/local/bin:$PATH

# export PATH

# sudo npm install -g yarn || { echo "FATAL: Failed on 'yarn install'"; exit 1; }
if ! [ -x "$(command -v yarn)" ]; then npm install yarn  >&2; else  echo 'yarn installed'; fi

PATH=$PWD/node_modules/yarn/bin:$PATH

export PATH
# Install dependencies
# yarn || { echo "FATAL: Failed on 'yarn'"; exit 1; }
# Set environment vars
cp .env.example .env
# Run tests written in ES6
# yarn test

# npm install || { echo "FATAL: Failed on 'npm install'"; exit 1; } 
# cd app
# npm install || { echo "FATAL: Failed on 'npm install'"; exit 1; } 
# cd ../test
# npm install || { echo "FATAL: Failed on 'npm install'"; exit 1; } 
# cd ../

# Functional, Integration, Unit and Acceptance Tests
printf "\n\n**** Mandatory: Testing ********************\n"

# npm test || { echo "FATAL: Failed on 'npm test'"; exit 1; } 

# Build Artifact Production
printf "\n\n**** Optional: Producing Build Artifacts ********************\n"


# tar -zcvf $JOB_NAME.BUILD-$BUILD_NUMBER.tar.gz build.sh app.yml app.env dist  Dockerfile docker-compose.yml pre-deploy.sh || { echo "FATAL: Failed on 'Artifact tar''"; exit 1; }


#dist is empty??? added deploy folder - maybe mistake in template
#tar --exclude='./node_modules' --exclude='./deploy' -zcvf ${JOB_NAME}-${BUILD_NUMBER}.tar.gz deploy/mae/* * .env .dockerignore .eslintignore .eslintrc .istanbul.yml .snyk .yarnrc || { echo "FATAL: Failed on 'Artifact tar''"; exit 1; }
tar -X deploy/mae/buildexcludefiles.txt -cvf ${JOB_NAME}-${BUILD_NUMBER}.tar -T deploy/mae/buildincludefiles.txt * || { echo "FATAL: Failed on 'Artifact tar''"; exit 1; }
tar -rvf ${JOB_NAME}-${BUILD_NUMBER}.tar -C deploy/mae --exclude='*.txt' . || { echo "FATAL: Failed on 'Artifact tar''"; exit 1;}
gzip ${JOB_NAME}-${BUILD_NUMBER}.tar || { echo "FATAL: Failed on 'Artifact tar''"; exit 1;}


printf "\n\n\n\n**** COMPLETED build.sh ********************\n\n"
