#!/bin/bash

echo
echo "Creating Custom Catalog Source for IBM DataPower"
echo

cat <<EOF | kubectl apply --validate=false -f -
apiVersion: operators.coreos.com/v1alpha1
kind: CatalogSource
metadata:
  name: ibm-datapower-operator-catalog
  namespace: openshift-marketplace
spec:
  displayName: IBM DataPower Operator
  publisher: IBM
  sourceType: grpc
  image: ibmcom/datapower-operator-catalog:latest
  updateStrategy:
    registryPoll:
      interval: 45m
EOF

