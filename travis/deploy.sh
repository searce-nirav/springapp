#!/usr/bin/env bash
#gcloud version || true
#if [ ! -d "$HOME/google-cloud-sdk/bin" ]; then rm -rf $HOME/google-cloud-sdk; export CLOUDSDK_CORE_DISABLE_PROMPTS=1; curl https://sdk.cloud.google.com | bash; fi

curl https://sdk.cloud.google.com | bash -s -- --disable-prompts > /dev/null
export PATH=${HOME}/google-cloud-sdk/bin:${PATH}
#gcloud --quiet components install kubectl

#gcloud components update
echo ${SA_KEY} | base64 --decode -i > ${HOME}/gcloud-service-key.json
gcloud auth activate-service-account ${SA_NAME} --key-file ${HOME}/gcloud-service-key.json
gcloud config set project ${PROJECT_ID}

#echo Y | sudo gcloud auth configure-docker
gcloud auth configure-docker -y

# VERSION=2.1.5
# OS=linux  # or "darwin" for OSX, "windows" for Windows.
# ARCH=amd64  # or "386" for 32-bit OSs, "arm64" for ARM 64.

# curl -fsSL "https://github.com/GoogleCloudPlatform/docker-credential-gcr/releases/download/v${VERSION}/docker-credential-gcr_${OS}_${ARCH}-${VERSION}.tar.gz" \
# | tar xz docker-credential-gcr \
# && chmod +x docker-credential-gcr && sudo mv docker-credential-gcr /usr/bin/

docker-credential-gcr configure-docker
docker build -t springapp-test:latest .
docker tag springapp-test:latest gcr.io/${PROJECT_ID}/springapp-test:latest
docker push gcr.io/${PROJECT_ID}/springapp-test:latest

#docker tag springapp-test:latest europe-west2-docker.pkg.dev/${PROJECT_ID}/travis-test/springapp-test:latest
#docker push europe-west2-docker.pkg.dev/${PROJECT_ID}/travis-test/springapp-test:


#Try using Container Registry