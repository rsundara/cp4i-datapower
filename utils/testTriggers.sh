#!/bin/bash

echo
echo "Util to test triggers"
echo

 
URL="https://github.ibm.com/rsundara/cp4i-datapower"
ROUTE_HOST=$(oc get route el-dp-demo --template='http://{{.spec.host}}')
echo $ROUTE_HOST
curl -v \
    -H 'X-GitHub-Event: pull_request' \
    -H 'Content-Type: application/json' \
    -d '{
      "repository": {"clone_url": "'"${URL}"'"},
      "pull_request": {"head": {"sha": "master"}}
    }' \
    ${ROUTE_HOST}
