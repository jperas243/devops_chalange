
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


resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = "test-bucket-cats"
  force_destroy = true
}

resource "aws_s3_bucket_acl" "codepipeline_bucket_acl" {
  bucket = aws_s3_bucket.codepipeline_bucket.id
  acl    = "private"
}

resource "aws_iam_role" "codepipeline_role" {
  name = "test-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}


#side note: this resour has FULL PERMISSIONS to act on ANY AWS Resource....it will be removed soon....
resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "codepipeline_policy"
  role = aws_iam_role.codepipeline_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketVersioning",
        "s3:PutObjectAcl",
        "s3:PutObject"
      ],
      "Resource": [
        "${aws_s3_bucket.codepipeline_bucket.arn}",
        "${aws_s3_bucket.codepipeline_bucket.arn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codestar-connections:UseConnection"
      ],
      "Resource": "${var.connection_github_arn}"
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "codestar-connections:UseConnection",
      "Resource": "${var.connection_github_arn}"
    },
    {
      "Action": "*",
      "Effect": "Allow",
      "Resource": "*"
    }
    
  ]
}
EOF
}