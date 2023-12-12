#!/usr/bin/bash
#Renew token
## Permanent token method
kubectl delete secret twistlock-sa-secret -n twistlock
kubectl apply -f ${SECRET_MANIFEST}
TOKEN=$(kubectl get secret twistlock-sa-secret -o jsonpath='{$.data.token}' -n "$NAMESPACE" | base64 -d)

## Temporary token method
# TOKEN=$(kubectl create token twistlock-service-account -n "$NAMESPACE" --duration 86400s)

kubectl config --kubeconfig ${KUBECONFIG_FILE} \
  set-credentials ${CONTEXT}-${NAMESPACE}-token-user \
  --token ${TOKEN}
