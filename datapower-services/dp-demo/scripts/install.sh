#!/bin/bash

echo
echo "Install IBM DataPower Service"
echo

# Set the project
PROJECT=cp4i-datapower
oc project $PROJECT

# Define the location of the directories
CONFIG_DIR=../drouter/config
LOCAL_DIR=../drouter/local
USRCERTS_DIR=../drouter/secure/usrcerts
MANIFESTS_DIR=../manifests

# Set the instance name
DP_SERVICE_NAME=dp-demo-dev
if [ ! -z "$SERVICE_NAME" ]; then 
  DP_SERVICE_NAME=$SERVICE_NAME; 
fi;

# Set the limits for resources
LIMITS_CPU=4
LIMITS_MEMORY=8Gi

# In case of production, it can be set to "3"
REPLICA_COUNT=1
if [ "$PRODUCTION" = "true" ]; then 
  REPLICA_COUNT=3; 
fi;

#
# Compute revised datapowerservice.yaml
# 
sed "s/PARM_DP_SERVICE_NAME/$DP_SERVICE_NAME/g"            $MANIFESTS_DIR/datapowerservice-template.yaml   > $MANIFESTS_DIR/datapowerservice_revised_1.yaml
sed "s/PARM_REPLICA_COUNT/$REPLICA_COUNT/g"                $MANIFESTS_DIR/datapowerservice_revised_1.yaml  > $MANIFESTS_DIR/datapowerservice_revised_2.yaml
sed "s/PARM_LIMITS_CPU/$LIMITS_CPU/g"                      $MANIFESTS_DIR/datapowerservice_revised_2.yaml  > $MANIFESTS_DIR/datapowerservice_revised_3.yaml
sed "s/PARM_LIMITS_MEMORY/$LIMITS_MEMORY/g"                $MANIFESTS_DIR/datapowerservice_revised_3.yaml  > $MANIFESTS_DIR/datapowerservice.yaml

rm $MANIFESTS_DIR/datapowerservice_revised_1.yaml
rm $MANIFESTS_DIR/datapowerservice_revised_2.yaml
rm $MANIFESTS_DIR/datapowerservice_revised_3.yaml

echo 
echo Contents of $MANIFESTS_DIR/datapowerservice.yaml
echo 
cat $MANIFESTS_DIR/datapowerservice.yaml
echo
echo

#
# Compute revised service.yaml
# 
DATAPOWER_INSTANCE_NAME=$PROJECT-$DP_SERVICE_NAME
sed "s/PARM_DATAPOWER_INSTANCE_NAME/$DATAPOWER_INSTANCE_NAME/g" $MANIFESTS_DIR/service-template.yaml  > $MANIFESTS_DIR/service.yaml

echo 
echo Contents of $MANIFESTS_DIR/service.yaml
echo 
cat $MANIFESTS_DIR/service.yaml
echo
echo

#
# Compute revised admin-route.yaml
# 

# Set the instance name
OCP_DOMAIN_SUFFIX=$DOMAIN_SUFFIX
if [ -z "$OCP_DOMAIN_SUFFIX" ]; then 
  OCP_DOMAIN_SUFFIX=$(oc get dns cluster -o yaml | grep baseDomain: | awk -F' ' '{print $2 }')
fi;

DP_ADMIN_HOST_NAME=dp-admin.$OCP_DOMAIN_SUFFIX
sed "s/PARM_DP_ADMIN_HOST_NAME/$DP_ADMIN_HOST_NAME/g"      $MANIFESTS_DIR/admin-route-template.yaml  > $MANIFESTS_DIR/admin-route.yaml

echo 
echo Contents of $MANIFESTS_DIR/admin-route.yaml
echo 
cat $MANIFESTS_DIR/admin-route.yaml
echo

#
# Compute revised app-route.yaml
# 
DP_DEMO_HOST_NAME=dp-demo.$OCP_DOMAIN_SUFFIX
sed "s/PARM_DP_DEMO_HOST_NAME/$DP_DEMO_HOST_NAME/g"        $MANIFESTS_DIR/app-route-template.yaml  > $MANIFESTS_DIR/app-route.yaml

echo 
echo Contents of $MANIFESTS_DIR/app-route.yaml
echo 
cat $MANIFESTS_DIR/app-route.yaml
echo

# Create tar file of contents of local directory of IDP application domain
tar --directory=$LOCAL_DIR/IDP -czvf idp-local.tar.gz .

#
# Create config maps
#
echo 
echo Create configMap objects to store application domain configurations
echo 
oc delete configmap web-mgmt
oc apply -f $MANIFESTS_DIR/web-mgmt-configmap.yaml 

oc delete configmap idp-config
oc create configmap idp-config --from-file=$CONFIG_DIR/IDP/IDP.cfg

oc delete configmap idp-local
oc create configmap idp-local  --from-file=./idp-local.tar.gz 

#
# Create secrets
#
echo 
echo Create secrets to store the certificates
echo 
oc delete secret idp-privkey
oc create secret generic idp-privkey --from-file=$USRCERTS_DIR/IDP/IDP-privkey.pem

oc delete secret idp-sscert
oc create secret generic idp-sscert  --from-file=$USRCERTS_DIR/IDP/IDP-sscert.pem 

oc delete secret admin-credentials
oc apply -f $MANIFESTS_DIR/admin-credentials.yaml 

#
# Create service and routes
#
echo 
echo Create service and routes 
echo 
oc apply -f $MANIFESTS_DIR/service.yaml
oc apply -f $MANIFESTS_DIR/admin-route.yaml
oc apply -f $MANIFESTS_DIR/app-route.yaml

#
# Create datapowerservice 
#
echo 
echo Create DataPower service
echo 
oc apply -f $MANIFESTS_DIR/datapowerservice.yaml 

# Perform cleanup of the temp files created
rm ./idp-local.tar.gz
rm $MANIFESTS_DIR/datapowerservice.yaml
rm $MANIFESTS_DIR/service.yaml
rm $MANIFESTS_DIR/admin-route.yaml
rm $MANIFESTS_DIR/app-route.yaml

echo
echo "Install of IBM DataPower Service is now complete"
echo
