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

resource "twilio_taskrouter_task_queue" "task_queue_placeholder" {
  workspace_sid  = data.twilio_taskrouter_workspaces.workspaces.workspaces[0].sid
  friendly_name  = "[IVR Reporting] Placeholder Queue"
  target_workers = "1==2"
}

resource "twilio_taskrouter_task_queue" "task_queue_everyone" {
  workspace_sid  = data.twilio_taskrouter_workspaces.workspaces.workspaces[0].sid
  friendly_name  = "[IVR Reporting] Everyone Queue"
  target_workers = "1==1"
}
