# The registry is bootstrapped separately so the image can be published before
# Terraform creates the service. CloudFormation owns this repository.
data "aws_ecr_repository" "app" {
  name = var.project_name
}
