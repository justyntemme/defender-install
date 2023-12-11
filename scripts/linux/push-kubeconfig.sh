#!/usr/bin/bash
#Generate Console TOKEN
CONSOLE_TOKEN=$(curl -k ${CONSOLE_URL}/api/v1/authenticate -X POST -H "Content-Type: application/json" -d '{
  "username":"'"$USERNAME"'",
  "password":"'"$PASSWORD"'"
  }'  | jq -r '.token')


#Push kubeconfig file to the Console
KUBECONFIG=$(sed -z 's/\n/\\n/g; s/..$//' $KUBECONFIG_FILE)
curl -k ${CONSOLE_URL}/api/v1/credentials -H 'Content-Type: application/json' -H "Authorization: Bearer $CONSOLE_TOKEN" -d '{
  "secret":{
      "plain":"'"$KUBECONFIG"'"
  },
  "description": "",
  "type": "kubeconfig",
  "_id": "'"$CREDENTIAL_ID"'"
}'