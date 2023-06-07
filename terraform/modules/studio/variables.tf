variable "workflows_ivr_reporting_sid" {
  type        = string
  description = "SID of Workflow - IVR Reporting"
}

variable "workflows_everyone_sid" {
  type        = string
  description = "SID of Workflow - Everyone"
}

variable "function_task_service_sid" {
  type        = string
  description = "SID of Function's Service"
}

variable "function_task_environment_sid" {
  type        = string
  description = "SID of Function's Environment"
}

variable "function_task_create_function_sid" {
  type        = string
  description = "SID of Function - Create Function"
}

variable "function_task_update_function_sid" {
  type        = string
  description = "SID of Function - Update Function"
}

variable "function_create_task_url" {
  type        = string
  description = "URL of Function - Create Task"
}

variable "function_update_task_url" {
  type        = string
  description = "URL of Function - Update Task"
}
