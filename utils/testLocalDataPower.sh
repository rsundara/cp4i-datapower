#!/bin/bash

echo
echo "Starting local DataPower instance using the configuration stored in the local directory"
echo

# Switch to the IBM DataPower config directory
cd ../datapower-services/dp-demo

# Start the IBM DataPower container using external volumes
docker run -it --name=demo-datapower --memory=4g  -v $PWD/drouter/config:/opt/ibm/datapower/drouter/config -v $PWD/drouter/local:/opt/ibm/datapower/drouter/local -v $PWD/drouter/secure/usrcerts:/opt/ibm/datapower/root/secure/usrcerts -e DATAPOWER_ACCEPT_LICENSE=true -e DATAPOWER_INTERACTIVE=true -e DATAPOWER_WORKER_THREADS=4 -p 9090:9090 -p 6443:6443 ibmcom/datapower
