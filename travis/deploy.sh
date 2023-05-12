echo ${SA_KEY} | base64 --decode -i > ${HOME}/gcloud-service-key.json
gcloud auth activate-service-account --key-file ${HOME}/gcloud-service-key.json

docker build -t springapp-test:latest .
docker tag springapp-test:latest europe-west2-docker.pkg.dev/${PROJECT_ID}/travis-test/springapp-test:latest
gcloud docker push europe-west2-docker.pkg.dev/${PROJECT_ID}/travis-test/springapp-test:latest