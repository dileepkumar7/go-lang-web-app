# terraform {
#   backend "s3" {
#     bucket       = "my-terraform-state-bucket"
#     key          = "jenkins/dev/terraform.tfstate"
#     region       = "us-east-1"
#     encrypt      = true
#     use_lockfile = true  # <-- This enables S3-native locking
#   }
# }
