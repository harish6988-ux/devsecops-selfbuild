#!/usr/bin/env bash
set -euo pipefail
aws ecs wait services-stable --cluster "$PROJECT_NAME" --services "$PROJECT_NAME"
task_arn=$(aws ecs list-tasks --cluster "$PROJECT_NAME" --service-name "$PROJECT_NAME" --desired-status RUNNING --query 'taskArns[0]' --output text)
test "$task_arn" != None
details=$(aws ecs describe-tasks --cluster "$PROJECT_NAME" --tasks "$task_arn")
echo "$details" | jq -e '.tasks[0].containers | all(.lastStatus == "RUNNING" and .healthStatus == "HEALTHY")'
actual_image=$(echo "$details" | jq -r '.tasks[0].containers[0].image')
test "$actual_image" = "$IMAGE_REF"
eni=$(echo "$details" | jq -r '.tasks[0].attachments[].details[] | select(.name == "networkInterfaceId") | .value')
public_ip=$(aws ec2 describe-network-interfaces --network-interface-ids "$eni" --query 'NetworkInterfaces[0].Association.PublicIp' --output text)
test "$public_ip" != None
{
  echo '### Verified ECS application'
  echo "- Image: $IMAGE_REF"
  echo "- Task: $task_arn"
  echo "- Demo URL (trusted IP only): http://$public_ip:8080/"
  echo '- HTTP demo with synthetic data; no authentication, TLS or load balancer.'
  echo '- The public IP can change after deployments or task replacement.'
} >> "$GITHUB_STEP_SUMMARY"
echo 'ECS task and container health verified. Open the demo URL from the allowed network.'
