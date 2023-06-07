output "TASK_QUEUE_PLACEHOLDER" {
  value       = module.task_queues.task_queue_placeholder_sid
  description = "SID of Placeholder Task Queue"
}

output "TASK_QUEUE_EVERYONE" {
  value       = module.task_queues.task_queue_everyone_sid
  description = "SID of Everyone Task Queue"
}

output "WORKFLOW_IVR_REPORTING" {
  value       = module.workflows.workflows_ivr_reporting_sid
  description = "SID of IVR Reporting Workflow"
}

output "WORKFLOW_EVERYONE" {
  value       = module.workflows.workflows_everyone_sid
  description = "SID of Everyone Workflow"
}

output "FUNCTION_CREATE_TASK_URL" {
  value       = module.functions.function_create_task_url
  description = "URL of Create Task Function"
}

output "FUNCTION_UPDATE_TASK_URL" {
  value       = module.functions.function_update_task_url
  description = "URL of Update Task Function"
}

output "STUDIO_IVR_REPORTING" {
  value       = module.studio.studio_flow_ivr_reporting_sid
  description = "SID of Studio Flow - IVR Reporting"
}

