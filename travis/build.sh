#!/usr/bin/env bash
gcloud --quiet components install kubectl

echo ${SA_KEY} | base64 --decode -i > ${HOME}/gcloud-service-key.json
gcloud auth activate-service-account ${SA_NAME} --key-file ${HOME}/gcloud-service-key.json


gcloud config set project ${PROJECT_ID}
gcloud container clusters get-credentials ${CLUSTER_NAME} --zone asia-south1-a --project ${PROJECT_ID}


echo Y | gcloud auth configure-docker europe-west2-docker.pkg.dev


docker build -t springapp-test:latest .
docker tag springapp-test:latest europe-west2-docker.pkg.dev/${PROJECT_ID}/travis-test/springapp-test:latest
docker push europe-west2-docker.pkg.dev/${PROJECT_ID}/travis-test/springapp-test:latest


#to update the image in k8 deployment
kubectl set image deployment/travis-spring-app spring-app=europe-west2-docker.pkg.dev/${PROJECT_ID}/travis-test/springapp-test:latest

# #get status of deployement
#kubectl get deployments

kubectl get pods

kubectl get services