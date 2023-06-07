terraform {
  required_providers {
    twilio = {
      source  = "RJPearson94/twilio"
      version = "0.23.0"
    }
  }
}

provider "twilio" {
  account_sid = var.TWILIO_ACCOUNT_SID
  auth_token  = var.TWILIO_AUTH_TOKEN
}

module "task_queues" {
  source = "../../modules/task-queues"
}

module "workflows" {
  source                     = "../../modules/workflows"
  task_queue_placeholder_sid = module.task_queues.task_queue_placeholder_sid
  task_queue_everyone_sid    = module.task_queues.task_queue_everyone_sid
}

module "functions" {
  source                      = "../../modules/functions"
  workflows_ivr_reporting_sid = module.workflows.workflows_ivr_reporting_sid
}

module "studio" {
  source                            = "../../modules/studio"
  workflows_ivr_reporting_sid       = module.workflows.workflows_ivr_reporting_sid
  workflows_everyone_sid            = module.workflows.workflows_everyone_sid
  function_task_service_sid         = module.functions.function_task_service_sid
  function_task_environment_sid     = module.functions.function_task_environment_sid
  function_task_create_function_sid = module.functions.function_task_create_function_sid
  function_task_update_function_sid = module.functions.function_task_update_function_sid
  function_create_task_url          = module.functions.function_create_task_url
  function_update_task_url          = module.functions.function_update_task_url
}
