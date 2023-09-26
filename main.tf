resource "random_string" "bucket_name" {
  length  = 32
  special = false
  lower   = true
  upper   = false

}

#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
resource "aws_s3_bucket" "terraform_bucket" {
  bucket = random_string.bucket_name.result

  tags = {
    UserUuid = var.user_uuid
  }
}

