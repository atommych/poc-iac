# poc-iac

This is a Terraform project that provisions the infrastructure needed to run an AWS Lambda function to execute an ETL process using Python code and store the data into a Amazon S3 Bucket.

## Prerequisites & Configuration

1. Install AWS CLI: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

2. Create AWS Account: https://aws.amazon.com/pt/account/

3. Create AWS Access Credentials: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html

4. Setup AWS Cli:	https://docs.aws.amazon.com/cli/latest/userguide/getting-started-quickstart.html

5. Install Terraform: https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
   
6. Create Terraform Account: 	https://app.terraform.io/

7. Create Terraform Cloud workspace:  https://app.terraform.io/app/<YOUR_ORGANIZATION>/workspaces/new

8. Create Terraform Cloud API token: https://app.terraform.io/app/settings/tokens

9. Add variables to terraform workspace: https://app.terraform.io/app/<YOUR_ORGANIZATION>/workspaces/<YOUR_WORKSPACE>/variables

   9.1. AWS_ACCESS_KEY_ID = AWS Access key ID (generated in step 3)

   9.2. AWS_SECRET_ACCESS_KEY = AWS Secret access key (generated in step 3)
   
   ![Terraform Variables](/docs/imgs/terraform_vars.png)

10. Login into Terraform with: *terraform login*

11. Update the *[providers.tf](https://github.com/atommych/poc-iac-iaas-etl/blob/main/providers.tf)* file with **YOUR Terraform Cloud organization** and **workspace**.

# Run
    
    terraform init    

    terraform plan 
    
    terraform apply 

# AWS Resources

## AWS Lambda Function

![AWS Lambda Function](/docs/imgs/aws_lambda.png)

## AWS S3 Bucket

![AWS S3 Bucket](/docs/imgs/aws_s3.png)


# Destroy
    
    terraform destroy

   ![Terraform Destroy](/docs/imgs/terraform_destroy.png)
