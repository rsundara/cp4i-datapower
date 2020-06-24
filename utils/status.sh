#!/bin/bash

echo "Getting the status of the OpenShift cluster"
echo

# Set the project
PROJECT=dp-demo
oc project $PROJECT

# Get the project status
oc get pods
oc get deployments
oc get sts
oc get services
oc get pvc
oc get jobs
oc get routes
oc get all
oc status

echo "Failing pods from ALL namespaces:"
oc get pods -A | egrep -v "1/1|2/2|3/3|4/4|5/5|6/6|7/7|8/8|9/9|Completed"
