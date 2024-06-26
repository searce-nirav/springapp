#!/usr/bin/env bash

#check what is available on the base image (vm specs)
df -h

gcloud --quiet components install kubectl


echo ${SA_KEY} | base64 --decode -i > ${HOME}/gcloud-service-key.json
gcloud auth activate-service-account ${SA_NAME} --key-file ${HOME}/gcloud-service-key.json


gcloud config set project ${PROJECT_ID}
gcloud container clusters get-credentials ${CLUSTER_NAME} --zone asia-south1-a --project ${PROJECT_ID}


echo Y | gcloud auth configure-docker europe-west2-docker.pkg.dev


docker build -t springapp-test:latest .
docker tag springapp-test:latest europe-west2-docker.pkg.dev/${PROJECT_ID}/travis-test/springapp-test:latest
docker push europe-west2-docker.pkg.dev/${PROJECT_ID}/travis-test/springapp-test:latest


#deploy to kubernetes cluster
kubectl apply -f ./deployment.yaml

# #get status of deployement
kubectl get deployments

kubectl get pods

kubectl get services


#FOR CONTAINER REGISTERY
#sudo docker tag springapp-test:latest us.gcr.io/${PROJECT_ID}/app-engine-tmp/app/my-first-service/ttl-18h/springapp-test:latest
#sudo docker push us.gcr.io/${PROJECT_ID}/app-engine-tmp/app/my-first-service/ttl-18h/springapp-test:latest



#deploy to cloud run
# echo Y | gcloud run services set-iam-policy travis-spring-app policy.yaml
# gcloud run services replace deployment.yaml --region us-central1


# gcloud run deploy travis-spring-app --image=europe-west2-docker.pkg.dev/${PROJECT_ID}/travis-test/springapp-test:latest --region=us-central1 --allow-unauthenticated




#add docker to group
# sudo groupadd docker
# sudo useradd travis
# sudo usermod -a -G docker travis

#sudo chown -R travis:docker /home/travis/.docker
#sudo chmod 777 "/home/travis/.docker"
