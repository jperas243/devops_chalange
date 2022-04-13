
#beanstalk
resource "aws_elastic_beanstalk_application" "cats_beanstalk" {
  name        = "cats-terraform"
  description = "cats_beanstalk"
}

resource "aws_elastic_beanstalk_environment" "cats_beanstalk_dev" {
  name                = "cats-terraform-dev"
  cname_prefix        = "cats-terraform-dev"
  application         = aws_elastic_beanstalk_application.cats_beanstalk.name
  solution_stack_name = "64bit Amazon Linux 2 v3.4.4 running Ruby 3.0"

  setting {
    namespace = "aws:ec2:vpc"
    name="VPCId"
    value = module.vpc.vpc_id
  }

  setting {
    namespace = "aws:ec2:vpc"
    name="Subnets"
    value = "${module.vpc.public_subnets[0]},${module.vpc.public_subnets[1]}"
  }

  setting {
      namespace = "aws:autoscaling:launchconfiguration"
      name = "IamInstanceProfile"
      value = "aws-elasticbeanstalk-ec2-role"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerType"
    value     = "application"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "Port"
    value     = "8000"
  }

}

resource "aws_elastic_beanstalk_environment" "cats_beanstalk_prod" {
  name                = "cats-terraform-prod"
  cname_prefix        = "cats-terraform-prod"
  application         = aws_elastic_beanstalk_application.cats_beanstalk.name
  solution_stack_name = "64bit Amazon Linux 2 v3.4.4 running Ruby 3.0"

  setting {
    namespace = "aws:ec2:vpc"
    name="VPCId"
    value = module.vpc.vpc_id
  }

  setting {
    namespace = "aws:ec2:vpc"
    name="Subnets"
    value = "${module.vpc.public_subnets[0]},${module.vpc.public_subnets[1]}"
  }

  setting {
      namespace = "aws:autoscaling:launchconfiguration"
      name = "IamInstanceProfile"
      value = "aws-elasticbeanstalk-ec2-role"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerType"
    value     = "application"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "Port"
    value     = "8000"
  }

}

resource "aws_s3_bucket" "deploy_bucket" {
  bucket = "deploy-cats"
  force_destroy = true

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.deploy_bucket.id
  acl    = "private"
}
