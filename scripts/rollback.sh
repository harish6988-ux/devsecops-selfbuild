#!/usr/bin/env bash
set -euo pipefail
: "${PROJECT_NAME:=devsecops-selfbuild}"
: "${ROLLBACK_TASK_DEFINITION:?Set the previous task definition ARN or family:revision}"
aws ecs update-service --cluster "$PROJECT_NAME" --service "$PROJECT_NAME" --task-definition "$ROLLBACK_TASK_DEFINITION" >/dev/null
aws ecs wait services-stable --cluster "$PROJECT_NAME" --services "$PROJECT_NAME"
echo 'Rollback completed. Update the desired image in the deployment configuration before the next Terraform apply.'
