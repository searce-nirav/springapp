#!/usr/bin/env bash
#gcloud version || true
#if [ ! -d "$HOME/google-cloud-sdk/bin" ]; then rm -rf $HOME/google-cloud-sdk; export CLOUDSDK_CORE_DISABLE_PROMPTS=1; curl https://sdk.cloud.google.com | bash; fi

curl https://sdk.cloud.google.com | bash -s -- --disable-prompts > /dev/null
export PATH=${HOME}/google-cloud-sdk/bin:${PATH}
#gcloud --quiet components install kubectl

gcloud components update
echo ${SA_KEY} | base64 --decode -i > ${HOME}/gcloud-service-key.json
gcloud auth activate-service-account ${SA_NAME} --key-file ${HOME}/gcloud-service-key.json
gcloud config set project ${PROJECT_ID}

#echo Y | sudo gcloud auth configure-docker
gcloud auth configure-docker
docker-credential-gcr configure-docker
docker build -t springapp-test:latest .
docker tag springapp-test:latest gcr.io/${PROJECT_ID}/springapp-test:latest
docker push gcr.io/${PROJECT_ID}/springapp-test:latest

#docker tag springapp-test:latest europe-west2-docker.pkg.dev/${PROJECT_ID}/travis-test/springapp-test:latest
#docker push europe-west2-docker.pkg.dev/${PROJECT_ID}/travis-test/springapp-test:


#Try using Container Registry