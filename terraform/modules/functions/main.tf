terraform {
  required_providers {
    twilio = {
      source  = "RJPearson94/twilio"
      version = "0.23.0"
    }
  }
}

# Obtain Default TaskRouter Workspace SID
data "twilio_taskrouter_workspaces" "workspaces" {
  friendly_name = "Flex Task Assignment"
}


resource "twilio_serverless_service" "service" {
  unique_name   = "ivr-reporting-handler"
  friendly_name = "[IVR Reporting] IVR Reporting Handler"
}

resource "twilio_serverless_environment" "environment" {
  service_sid = twilio_serverless_service.service.sid
  unique_name = "ivr-reporting"
}

resource "twilio_serverless_variable" "workspace_sid" {
  service_sid     = twilio_serverless_service.service.sid
  environment_sid = twilio_serverless_environment.environment.sid
  key             = "TWILIO_WORKSPACE_SID"
  value           = data.twilio_taskrouter_workspaces.workspaces.workspaces[0].sid
}

resource "twilio_serverless_variable" "ivr_reporting_workflow_sid" {
  service_sid     = twilio_serverless_service.service.sid
  environment_sid = twilio_serverless_environment.environment.sid
  key             = "TWILIO_IVR_REPORTING_WORKFLOW_SID"
  value           = var.workflows_ivr_reporting_sid
}

resource "twilio_serverless_function" "function_create_task" {
  service_sid   = twilio_serverless_service.service.sid
  friendly_name = "tr-event-callback"
  source        = "../../../function-ivr-handler/functions/create-task.protected.js"
  content_type  = "application/javascript"
  path          = "/create-task"
  visibility    = "protected"
}

resource "twilio_serverless_function" "function_update_task" {
  service_sid   = twilio_serverless_service.service.sid
  friendly_name = "tr-event-callback"
  source        = "../../../function-ivr-handler/functions/update-task.protected.js"
  content_type  = "application/javascript"
  path          = "/update-task"
  visibility    = "protected"
}

resource "twilio_serverless_build" "build" {
  service_sid = twilio_serverless_service.service.sid

  function_version {
    sid = twilio_serverless_function.function_create_task.latest_version_sid
  }

  function_version {
    sid = twilio_serverless_function.function_update_task.latest_version_sid
  }

  dependencies = {
    "@twilio/runtime-handler" = "1.3.0",
    "twilio"                  = "^3.56"
  }

  polling {
    enabled = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "twilio_serverless_deployment" "deployment" {
  service_sid     = twilio_serverless_service.service.sid
  environment_sid = twilio_serverless_environment.environment.sid
  build_sid       = twilio_serverless_build.build.sid

  lifecycle {
    create_before_destroy = true
  }
}
