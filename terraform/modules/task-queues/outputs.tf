output "task_queue_placeholder_sid" {
  value       = twilio_taskrouter_task_queue.task_queue_placeholder.id
  description = "[IVR Reporting] Task Queue - Placeholder"
}

output "task_queue_everyone_sid" {
  value       = twilio_taskrouter_task_queue.task_queue_everyone.id
  description = "[IVR Reporting] Task Queue - Everyone"
}
