output "workflows_ivr_reporting_sid" {
  value       = twilio_taskrouter_workflow.workflow.id
  description = "Workflow - IVR Reporting SID"
}

output "workflows_everyone_sid" {
  value       = twilio_taskrouter_workflow.workflow_everyone.id
  description = "Workflow - Everyone SID"
}
