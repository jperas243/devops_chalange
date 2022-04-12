
resource "aws_codepipeline" "codepipeline" {
  name     = "tf-test-pipeline-2"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = "${var.connection_github_arn}"
        FullRepositoryId = var.github_repo
        BranchName       = var.github_branch
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name = "Deploy"
      category = "Deploy"
      owner = "AWS"
      provider = "ElasticBeanstalk"
      input_artifacts = [
        "source_output"]
      version = "1"

      configuration = {
        ApplicationName = "${aws_elastic_beanstalk_application.cats_beanstalk.name}"
        EnvironmentName = "${aws_elastic_beanstalk_environment.cats_beanstalk_dev.name}"
      }
    }
  }
}