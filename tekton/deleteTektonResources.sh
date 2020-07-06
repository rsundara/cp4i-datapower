#!/bin/sh

echo "Start deleting resources created for the Tekton pipeline"
echo 


oc project datapower

oc delete -f ./manifests/datapower-secrets.yaml
oc delete -f ./manifests/datapower-resources.yaml
oc delete -f ./manifests/install-datapower-task.yaml
oc delete -f ./manifests/install-datapower-pipeline.yaml
oc delete -f ./manifests/uninstall-datapower-task.yaml
oc delete -f ./manifests/uninstall-datapower-pipeline.yaml
oc delete -f ./manifests/dp-demo-trigger-template.yaml
oc delete -f ./manifests/dp-demo-trigger-binding.yaml
oc delete -f ./manifests/dp-demo-event-listener.yaml
oc delete -f ./manifests/dp-demo-event-listener-route.yaml
oc delete Role dp-demo
oc delete RoleBinding dp-demo
oc delete ServiceAccount dp-demo