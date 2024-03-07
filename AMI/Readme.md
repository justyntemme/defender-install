## Usage

### First ensure your Prisma cloud service account and Twistlock console URL are provided ``

```
aws ssm put-parameter --name TL_URL --value "your_tl_url_value" --type SecureString
aws ssm put-parameter --name PC_IDENTITY --value "your_pc_identity_value" --type SecureString
aws ssm put-parameter --name PC_SECRET --value "your_pc_secret_value" --type SecureString
```

### Run Script from cmd

```
aws ssm start-automation-execution --document-name "ami_builder_automation_document.json" --parameters "TL_URL=your_tl_url_value,PC_IDENTITY=your_pc_identity_value,PC_SECRET=your_pc_secret_value"
```


## import secrets automagically
              # Fetch secrets from AWS Secrets Manager for access and secret keys
              SECRETS=$(aws secretsmanager get-secret-value --secret-id PrismaCloudAuth --query SecretString --output text)
              ACCESS_KEY=$(echo $SECRETS | jq -r '.PrissmaCloudConsoleAccessKey')
              SECRET_KEY=$(echo $SECRETS | jq -r '.PrissmaCloudConsoleSecretKey')
              
              # Use the PrissmaCloudConsoleURL parameter for the BASE_URL
              BASE_URL=${PrissmaCloudConsoleURL}
