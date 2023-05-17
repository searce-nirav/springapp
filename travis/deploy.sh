#!/usr/bin/env bash
#gcloud version || true
#if [ ! -d "$HOME/google-cloud-sdk/bin" ]; then rm -rf $HOME/google-cloud-sdk; export CLOUDSDK_CORE_DISABLE_PROMPTS=1; curl https://sdk.cloud.google.com | bash; fi

curl https://sdk.cloud.google.com | bash -s -- --disable-prompts > /dev/null
export PATH=${HOME}/google-cloud-sdk/bin:${PATH}
#gcloud init --skip-diagnostics -y

#gcloud --quiet components install kubectl

# curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-430.0.0-linux-x86_64.tar.gz
# tar -xf google-cloud-cli-430.0.0-linux-x86.tar.gz
# ./google-cloud-sdk/install.sh
# ./google-cloud-sdk/bin/gcloud init


#gcloud components update
echo ${SA_KEY} | base64 --decode -i > ${HOME}/gcloud-service-key.json
#cat ${HOME}/gcloud-service-key.json
gcloud auth activate-service-account ${SA_NAME} --key-file ${HOME}/gcloud-service-key.json
gcloud auth list
gcloud config set account ${SA_NAME}
gcloud config set project ${PROJECT_ID}
gcloud projects list

whoami

#add docker to group
sudo groupadd docker
sudo useradd travis
sudo usermod -a -G docker travis


#resolve config file error
# sudo chown $(whoami):docker /home/$(whoami)/.docker/config.json


#1
echo Y | sudo gcloud auth configure-docker

sudo chown -R $(whoami):docker /home/$(whoami)/.docker/config.json
sudo chmod -R g+rw "/home/travis/.docker"

#2
VERSION=2.1.5
OS=linux  # or "darwin" for OSX, "windows" for Windows.
ARCH=amd64  # or "386" for 32-bit OSs, "arm64" for ARM 64.

curl -fsSL "https://github.com/GoogleCloudPlatform/docker-credential-gcr/releases/download/v${VERSION}/docker-credential-gcr_${OS}_${ARCH}-${VERSION}.tar.gz" \
| tar xz docker-credential-gcr \
&& chmod +x docker-credential-gcr && sudo mv docker-credential-gcr /usr/bin/


#3
docker-credential-gcr configure-docker


sudo docker build -t springapp-test:latest .
sudo docker tag springapp-test:latest us.gcr.io/${PROJECT_ID}/app-engine-tmp/app/my-first-service/ttl-18h/springapp-test:latest
sudo docker push us.gcr.io/${PROJECT_ID}/app-engine-tmp/app/my-first-service/ttl-18h/springapp-test:latest

#docker tag springapp-test:latest europe-west2-docker.pkg.dev/${PROJECT_ID}/travis-test/springapp-test:latest
#docker push europe-west2-docker.pkg.dev/${PROJECT_ID}/travis-test/springapp-test:
