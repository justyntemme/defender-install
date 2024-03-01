## Usage

### First ensure your Prisma cloud service account and Twistlock console URL are provided ``

```aws ssm put-parameter --name TL_URL --value "your_tl_url_value" --type SecureString
aws ssm put-parameter --name PC_IDENTITY --value "your_pc_identity_value" --type SecureString
aws ssm put-parameter --name PC_SECRET --value "your_pc_secret_value" --type SecureString
```

### Run Script from cmd

```aws ssm start-automation-execution --document-name "YourDocumentName" --parameters TL_URL="your_tl_url_value" PC_IDENTITY="your_pc_identity_value" PC_SECRET="your_pc_secret_value"
```
