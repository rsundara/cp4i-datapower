#!/usr/bin/env bash

#
# The following section needs to be completed to match the environment 
#

# Credentials to access git repository
# API Key can be created using the link --> https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token-for-the-command-line
GIT_USER_NAME=xxx
GIT_API_KEY_OR_PASSWORD=xxx

# Domain suffix 
# Run the following command to get the domain suffix
# ---> oc get dns cluster -o yaml | grep baseDomain: | awk -F' ' '{print $2 }'
OPENSHIFT_CLUSTER_DOMAIN_SUFFIX=xxx

#
# End of configuration
# 
