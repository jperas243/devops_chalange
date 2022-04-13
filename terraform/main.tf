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
variable "github_tag" {}


provider "aws" {
  region     = "eu-central-1"
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "null_resource" "deploy_cats_dev" {
 
 count = 1

 provisioner "local-exec" {
    working_dir = "${path.module}"
    
    command = <<EOT
      echo 'hello'
      rm -rf ../workspace
      mkdir -p ../workspace
      cd ../workspace
      git clone ${var.github_repo}
      cd cats
      git checkout ${var.github_tag}
      git archive -v -o ruby.zip --format=zip HEAD
      aws s3 --profile indie cp ruby.zip s3://${aws_s3_bucket.deploy_bucket.bucket}/
      aws elasticbeanstalk --profile indie create-application-version --application-name ${aws_elastic_beanstalk_application.cats_beanstalk.name} --version-label ${var.github_tag} --source-bundle S3Bucket="${aws_s3_bucket.deploy_bucket.bucket}",S3Key="ruby.zip"
      aws elasticbeanstalk --profile indie update-environment --application-name ${aws_elastic_beanstalk_application.cats_beanstalk.name} --environment-name ${aws_elastic_beanstalk_environment.cats_beanstalk_dev.name} --version-label ${var.github_tag}

      cd ${path.module}
      rm -rf ../workspace

    EOT
    interpreter = ["/bin/bash", "-c"]

  
  }
}


resource "null_resource" "deploy_cats_prod" {
 
 count = 1
 depends_on = [
   null_resource.deploy_cats_dev,aws_elastic_beanstalk_environment.cats_beanstalk_dev
 ]

 provisioner "local-exec" {
    working_dir = "${path.module}"
    
    command = <<EOT
      echo 'hello'
      rm -rf ../workspace
      mkdir -p ../workspace
      cd ../workspace
      git clone ${var.github_repo}
      cd cats
      git checkout 1.0.0
      git archive -v -o ruby.zip --format=zip HEAD
      aws s3 --profile indie cp ruby.zip s3://${aws_s3_bucket.deploy_bucket.bucket}/
      aws elasticbeanstalk --profile indie create-application-version --application-name ${aws_elastic_beanstalk_application.cats_beanstalk.name} --version-label 1.0.0 --source-bundle S3Bucket="${aws_s3_bucket.deploy_bucket.bucket}",S3Key="ruby.zip"
      aws elasticbeanstalk --profile indie update-environment --application-name ${aws_elastic_beanstalk_application.cats_beanstalk.name} --environment-name ${aws_elastic_beanstalk_environment.cats_beanstalk_prod.name} --version-label 1.0.0

      cd ${path.module}
      rm -rf ../workspace

    EOT
    interpreter = ["/bin/bash", "-c"]

  
  }
}


resource "null_resource" "swap" {
 
 count = 0
 depends_on = [
   null_resource.deploy_cats_prod,aws_elastic_beanstalk_environment.cats_beanstalk_prod
 ]

 provisioner "local-exec" {
    working_dir = "${path.module}"
    
    command = <<EOT
      aws elasticbeanstalk --profile indie swap-environment-cnames --source-environment-id ${aws_elastic_beanstalk_environment.cats_beanstalk_prod.id} --destination-environment-id ${aws_elastic_beanstalk_environment.cats_beanstalk_dev.id}

    EOT
    interpreter = ["/bin/bash", "-c"]

  
  }
}
