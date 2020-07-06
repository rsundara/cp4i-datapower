#!/bin/bash

echo
echo "Uninstall IBM DataPower Service"
echo

# Set the project
PROJECT=datapower
oc project $PROJECT

# Define the location of the directories
MANIFESTS_DIR=../manifests

# Set the instance name
DP_SERVICE_NAME=dp-demo-dev
if [ ! -z "$SERVICE_NAME" ]; then 
  DP_SERVICE_NAME=$SERVICE_NAME; 
fi;

# Delete datapowerservice 
oc delete datapowerservice $DP_SERVICE_NAME

# Delete config maps
oc delete configmap web-mgmt
oc delete configmap idp-config 
oc delete configmap idp-local 

# Delete secrets
oc delete secret idp-sscert
oc delete secret idp-privkey
oc delete secret admin-credentials

# Delete service and routes
oc delete service dp-demo-service
oc delete route dp-admin
oc delete route dp-demo

echo
echo "Uninstall of IBM DataPower Service is now complete"
echo
