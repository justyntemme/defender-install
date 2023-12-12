# Linux Scripts to manage Kubeconfig of Service Account for Auto-Deploy
## Environment variables

The Environment variables are listed in the *.env* file. These are the following: 

* **SERVICE_ACCOUNT_NAME**: Name of the service account used
* **CONTEXT**: Kubeconfig current context. No change needed
* **NAMESPACE**: Namespace where the service account was deployed.
* **NEW_CONTEXT**: New context name.
* **KUBECONFIG_FILE**: Name of the kubeconfig file to be generated.
* **CREDENTIAL_ID**: Credential ID to be posted on prisma cloud compute console.
* **CONSOLE_URL**: Url of the prisma cloud compute console. Found under *Manage* > *System* > *Utilities*.
* **USERNAME**: User to login to the compute console. Can be Access Key for SaaS version.
* **PASSWORD**: Password to login to the compute console. Can be Secret Key for SaaS version.
* **CONSOLE_ADDRESS**: Name to be used for the defender to connect to the compute console.
* **SECRET_MANIFEST**: Path of the secret for service account token.
* **TOKEN**: Service account token. Can be temporary or permanent

Edit the *.env* file according to your environment

## Usage
1. Load environment variables
```bash
source .env
```

2. Generate kubeconfig
```bash
envsubst < generate-kubeconfig.sh | sh
```

3. Push Kubeconfig to Compute Console
```bash
envsubst '$CONSOLE_URL $USERNAME $PASSWORD $KUBECONFIG_FILE $KUBECONFIG_NAME' < push-kubeconfig.sh | sh
```

4. Deploy defender
```bash
envsubst '$CONSOLE_URL $USERNAME $PASSWORD $KUBECONFIG_FILE $CREDENTIAL_ID $CONSOLE_ADDRESS $NAMESPACE' < deploy-defender.sh | sh 
```

5. Renew Token (optional)
```bash
envsubst '$CONTEXT $NAMESPACE $KUBECONFIG_FILE $SECRET_MANIFEST' < renew-token.sh | sh 
```
> **NOTE**
> * This script reuses the current existing kubeconfig file and updates the token. If it doesn't exists you need to run step 2 before this step.
> * After executing this step you must execute step 3 and, as optional, step 4.
> <br></br>