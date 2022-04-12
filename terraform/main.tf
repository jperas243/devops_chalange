terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.9.0"
    }
  }
}

variable "access_key" {}
variable "secret_key" {}
#variable "github_token" {}
#variable "github_owner" {}
variable "github_repo" {}
variable "github_branch" {}
variable "connection_github_arn" {}


provider "aws" {
  region     = "eu-central-1"
  access_key = var.access_key
  secret_key = var.secret_key
}


#module.vpc.public_subnets[0]
#module.vpc.vpc_id


/*

resource "aws_s3_bucket" "dist_bucket" {
  bucket = "cats-artifact"
  acl    = "private"
}

resource "aws_s3_bucket_object" "dist_item" {
  key    = "cats-artifact"
  bucket = "${aws_s3_bucket.dist_bucket.id}"
  source = "${path.root}/../cats.zip"

  depends_on = [
    data.archive_file.api_dist_zip
  ]
}

data "archive_file" "api_dist_zip" {
  type        = "zip"
  source_file = "${path.root}/../cats"
  output_path = "${path.root}/../cats.zip"
}
*/



/*
resource "aws_codestarconnections_connection" "example" {
  name          = "jperas243"
  provider_type = "GitHub"
}
*/


