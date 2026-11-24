output "cluster_name" {
  value = aws_ecs_cluster.app.name
}

output "service_name" {
  value = aws_ecs_service.app.name
}

output "deployed_image" {
  value = var.image_ref
}

output "repository_url" {
  value = data.aws_ecr_repository.app.repository_url
}

output "log_group" {
  value = aws_cloudwatch_log_group.app.name
}
