#!/usr/bin/env bash

echo "Start creating resources for the Tekton pipeline"
echo 

oc new-project cp4i-datapower

# Update the initial configuration
. ./initConfig.sh

BASE64_GIT_API_KEY_OR_PASSWORD=`echo -n $GIT_API_KEY_OR_PASSWORD | base64`
BASE64_GIT_USER_NAME=`echo -n $GIT_USER_NAME | base64`
BASE64_DOMAIN_SUFFIX=`echo -n $OPENSHIFT_CLUSTER_DOMAIN_SUFFIX | base64`

sed "s/BASE64_GIT_API_KEY_OR_PASSWORD/$BASE64_GIT_API_KEY_OR_PASSWORD/g"  ./manifests/datapower-secrets-template.yaml    > ./manifests/datapower-secrets-revised-1.yaml
sed "s/BASE64_GIT_USER_NAME/$BASE64_GIT_USER_NAME/g"                      ./manifests/datapower-secrets-revised-1.yaml   > ./manifests/datapower-secrets-revised-2.yaml
sed "s/BASE64_DOMAIN_SUFFIX/$BASE64_DOMAIN_SUFFIX/g"                      ./manifests/datapower-secrets-revised-2.yaml   > ./manifests/datapower-secrets.yaml

# Create Tekton resources
oc create -f ./manifests/datapower-secrets.yaml
oc create -f ./manifests/datapower-resources.yaml
oc create -f ./manifests/install-datapower-task.yaml
oc create -f ./manifests/install-datapower-pipeline.yaml
oc create -f ./manifests/uninstall-datapower-task.yaml
oc create -f ./manifests/uninstall-datapower-pipeline.yaml
oc create -f ./manifests/dp-demo-serviceAccount.yaml
oc create -f ./manifests/dp-demo-trigger-template.yaml
oc create -f ./manifests/dp-demo-trigger-binding.yaml
oc create -f ./manifests/dp-demo-event-listener.yaml
oc create -f ./manifests/dp-demo-event-listener-route.yaml

# Cleanup the temp files created 
rm ./manifests/datapower-secrets-revised-1.yaml
rm ./manifests/datapower-secrets-revised-2.yaml
