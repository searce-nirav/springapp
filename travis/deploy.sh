#!/usr/bin/env bash
#gcloud version || true
#if [ ! -d "$HOME/google-cloud-sdk/bin" ]; then rm -rf $HOME/google-cloud-sdk; export CLOUDSDK_CORE_DISABLE_PROMPTS=1; curl https://sdk.cloud.google.com | bash; fi

#curl https://sdk.cloud.google.com | bash -s -- --disable-prompts > /dev/null
#export PATH=${HOME}/google-cloud-sdk/bin:${PATH}
#gcloud --quiet components install kubectl

curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-430.0.0-linux-x86_64.tar.gz
tar -xf google-cloud-cli-430.0.0-linux-x86.tar.gz
./google-cloud-sdk/install.sh
./google-cloud-sdk/bin/gcloud init

#gcloud components update
echo ${SA_KEY} | base64 --decode -i > ${HOME}/gcloud-service-key.json
#cat ${HOME}/gcloud-service-key.json
gcloud auth activate-service-account ${SA_NAME} --key-file ${HOME}/gcloud-service-key.json
gcloud config set project ${PROJECT_ID}


#add docker to group
# sudo groupadd docker
# sudo usermod -aG docker ${SA_NAME}
# newgrp docker
# docker run hello-world

#echo Y | sudo gcloud auth configure-docker
gcloud auth configure-docker -y

docker-credential-gcr configure-docker
docker build -t springapp-test:latest .
docker tag springapp-test:latest us.gcr.io/${PROJECT_ID}/app-engine-tmp/springapp-test:latest
docker push us.gcr.io/${PROJECT_ID}/app-engine-tmp/springapp-test:latest

#docker tag springapp-test:latest europe-west2-docker.pkg.dev/${PROJECT_ID}/travis-test/springapp-test:latest
#docker push europe-west2-docker.pkg.dev/${PROJECT_ID}/travis-test/springapp-test:


#us.gcr.io/thematic-metric-381904/app-engine-tmp
#us.gcr.io/thematic-metric-381904/app-engine-tmp/app/my-first-service/ttl-18h