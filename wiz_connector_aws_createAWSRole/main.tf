terraform {
  required_providers {
    wiz = {
      source = "tf.app.wiz.io/wizsec/wiz"
    }
  }
}

# This module creates a role in AWS for a Wiz AWS connector
# This is provided in Wiz when setting up an AWS connector with Account/Standard/Terraform options selected
# The external-ID is the Wiz tenant ID
module "aws_wiz_role" {
  source                    = "https://wizio-public.s3.amazonaws.com/deployment-v3/aws/terraform/2607/wiz-aws-native-terraform-terraform-module.zip"
  external-id               = "ce56e3d3-045d-4fbb-a077-b4aac64b6d82"
  data-scanning             = true
  lightsail-scanning        = false
  eks-scanning              = true
  remote-arn                = "arn:aws:iam::851725410668:role/prod-us100-AssumeRoleDelegator"
  terraform-bucket-scanning = true
  cloud-cost-scanning       = true
}


# Create AWS CloudTrail trail, S3 bucket, sqs queue, and policies for enabling CloudTrail ingest in Wiz
module "aws_cloud_events" {
  source = "https://wizio-public.s3.amazonaws.com/deployment-v3/aws/terraform/2607/wiz-aws-cloud-events-terraform-module.zip"
  integration_type = "S3"
  cloudtrail_bucket_arn = "sandwick-cloudtrail-s3-bucket"
  wiz_access_role_arn = "arn:aws:iam::034817877097:role/WizAccess-Role"
}




# Create Wiz - AWS connector
resource "wiz_aws_connector" "test_connector_sanity" {
  depends_on = [module.aws_wiz_role]
  name = "sandwick-test-tf-connector"
  auth_params {
    customer_role_arn = module.aws_wiz_role.role_arn
  }
  extra_config {
    skip_organization_scan = true
  }
}