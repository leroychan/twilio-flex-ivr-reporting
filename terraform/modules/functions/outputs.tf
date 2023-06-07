output "function_task_service_sid" {
  value       = twilio_serverless_service.service.sid
  description = "Service - Task SID"
}

output "function_task_environment_sid" {
  value       = twilio_serverless_environment.environment.sid
  description = "Environment - Task SID"
}


output "function_create_task_url" {
  value       = "https://${twilio_serverless_environment.environment.domain_name}${twilio_serverless_function.function_create_task.path}"
  description = "URL of the Create Task function."
}

output "function_update_task_url" {
  value       = "https://${twilio_serverless_environment.environment.domain_name}${twilio_serverless_function.function_update_task.path}"
  description = "URL of the Update Task function."
}

output "function_task_create_function_sid" {
  value       = twilio_serverless_function.function_create_task.sid
  description = "SID of Function - Create Function"
}

output "function_task_update_function_sid" {
  value       = twilio_serverless_function.function_update_task.sid
  description = "SID of Function - Update Function"
}
