$SERVICE_ACCOUNT_NAME="twistlock-service-account"
$CONTEXT=$(kubectl config current-context --insecure-skip-tls-verify)
$NAMESPACE="twistlock"
$NEW_CONTEXT="twistlock-context"
$KUBECONFIG_FILE="kubeconfig-sa"

# Temporary token method
#$TOKEN=$(kubectl create token $SERVICE_ACCOUNT_NAME -n $NAMESPACE --duration=0s)

# Permanent token method
$TOKEN=$(kubectl get secret twistlock-sa-secret -o jsonpath='{$.data.token}' -n $NAMESPACE --insecure-skip-tls-verify | openssl enc -base64 -d -A) 

# Create a full copy
kubectl config view --raw --insecure-skip-tls-verify > "$KUBECONFIG_FILE.full.tmp"
# Switch working context to correct context
kubectl --kubeconfig "$KUBECONFIG_FILE.full.tmp" config use-context $CONTEXT --insecure-skip-tls-verify
# Minify
kubectl --kubeconfig "$KUBECONFIG_FILE.full.tmp" config view --flatten --minify --insecure-skip-tls-verify > "$KUBECONFIG_FILE.tmp"
# Rename context
kubectl config --kubeconfig "$KUBECONFIG_FILE.tmp" rename-context $CONTEXT $NEW_CONTEXT --insecure-skip-tls-verify
# Create token user
kubectl config --kubeconfig "$KUBECONFIG_FILE.tmp" set-credentials "$CONTEXT-$NAMESPACE-token-user" --token $TOKEN --insecure-skip-tls-verify
# Set context to use token user
kubectl config --kubeconfig "$KUBECONFIG_FILE.tmp" set-context $NEW_CONTEXT --user "$CONTEXT-$NAMESPACE-token-user" --insecure-skip-tls-verify
# Set context to correct namespace
kubectl config --kubeconfig "$KUBECONFIG_FILE.tmp" set-context $NEW_CONTEXT --namespace $NAMESPACE --insecure-skip-tls-verify
# Flatten/minify kubeconfig
kubectl config --kubeconfig "$KUBECONFIG_FILE.tmp" view --flatten --minify --insecure-skip-tls-verify > $KUBECONFIG_FILE
# Remove tmp
rm "$KUBECONFIG_FILE.full.tmp"
rm "$KUBECONFIG_FILE.tmp"

# SIG # Begin signature block
# MIIFlAYJKoZIhvcNAQcCoIIFhTCCBYECAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU6yVmOxSC3zFs0W3ouHzIxGUh
# Tx6gggMiMIIDHjCCAgagAwIBAgIQediNCB9MtodFMf7SFhfnlzANBgkqhkiG9w0B
# AQsFADAnMSUwIwYDVQQDDBxQb3dlclNoZWxsIENvZGUgU2lnbmluZyBDZXJ0MB4X
# DTIzMTIxMTE4MzIyN1oXDTI0MTIxMTE4NTIyN1owJzElMCMGA1UEAwwcUG93ZXJT
# aGVsbCBDb2RlIFNpZ25pbmcgQ2VydDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCC
# AQoCggEBAMZRf8RrD+NaM3o176XU9MX/3RpKjXJoK/VeCX+LXS2PlBABgSO6XvJF
# 7uK8pkjnA/gE80cZ0Fr9kiHGIqnv8ZAB/lJIAT+2bI7bvKdc8KrgSbtmIYjziklB
# jAoKv5DRPx49bmbOeyUxYgj+F6tC6tLEJWBTBxSgP5iXj9UMTxSBDow3qLv7FUvP
# VqvG0oEZL5O4MTyzLR41aO9eBibzX4bwQ8olkZS2lKf1bHL/sY3ntPJMpKrjnC19
# vszPtZq3J8o7UmZtp4+PMr1fmxZziCWpoY21d5hNBrHJHXM4Ywu2cUtgPz050Kj1
# ImLdAmVuf/HbG54a/iNElUVmu8pGChkCAwEAAaNGMEQwDgYDVR0PAQH/BAQDAgeA
# MBMGA1UdJQQMMAoGCCsGAQUFBwMDMB0GA1UdDgQWBBSle8t13hRnum1+M4SJBuUL
# pxF68DANBgkqhkiG9w0BAQsFAAOCAQEAW1tYO49edljuxQE6tzU77OEza25x6DS4
# Ec2zPDLzdYDtqnEJdEy3d7vv3EMOr0eUcurt6cv72a05H0C2bXlCfqRb47v3qQ/o
# je4zHCB0BlS6ZeD7dJvUAQHCA+S/1q5Z1y56y8NN043kPvY4KP4EvcmXhWBttvXg
# VR69nmnyg7suGLgsl1MnLT2cay2Ft3+Vu//MZXOeUFva7qLHibTE/hn54eTka6up
# iRR/WMwEWGbTBLV4QNpTGAPwACNCiz07QHZOYR9iO3umqthC0a/R3KeHtaKPAsMJ
# 405JAESIN40CbHXnijVdsB95V/mH7+cl4izRnDzyJOtixsgKtqbrKjGCAdwwggHY
# AgEBMDswJzElMCMGA1UEAwwcUG93ZXJTaGVsbCBDb2RlIFNpZ25pbmcgQ2VydAIQ
# ediNCB9MtodFMf7SFhfnlzAJBgUrDgMCGgUAoHgwGAYKKwYBBAGCNwIBDDEKMAig
# AoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgEL
# MQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQU4lMUoAtJUhIWDUEyXELK
# unrc++0wDQYJKoZIhvcNAQEBBQAEggEAP+5z7GTZk4cIaDoLwaBv6BibGtSmCtUj
# DBy3SxbZxMgSNKbdqiVxHRJSRyYZgjHSYYZIgD6NrXSB0btzN6HaSw1/+55Rk/O0
# rNIbUaCGQQ6nyAE3Q239gfj+oBmXZgWUTC/vlEgFOT+qybCh4q3gFucnXrLDvarZ
# U7jjHhNrBTN6z26S3x15YEhSwBulI3xl+S8d676FubZ2KR5qccn/jYzW6O3koBgt
# DjdK174M9aPNHcju4OHi+695FLR+FgL4k2BDRCtQMa8MMA6qU57DmXTfS0aOXqy7
# p95Yjn5bqhX/H+ydTgcSEEQ1Uz22ycqsX8FWjlbGlS1JXHZmwd1qUQ==
# SIG # End signature block
