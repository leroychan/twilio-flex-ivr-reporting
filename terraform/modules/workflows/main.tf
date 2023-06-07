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

resource "twilio_taskrouter_workflow" "workflow" {
  workspace_sid = data.twilio_taskrouter_workspaces.workspaces.workspaces[0].sid
  friendly_name = "[IVR Reporting] Workflow"
  configuration = jsonencode({
    "task_routing" : {
      "filters" : [
        {
          "filter_friendly_name" : "Black Hole to IVR Reporting Queue",
          "expression" : "1==1",
          "targets" : [
            {
              "queue" : var.task_queue_placeholder_sid
            }
          ]
        }
      ]
    }
  })
}

resource "twilio_taskrouter_workflow" "workflow_everyone" {
  workspace_sid = data.twilio_taskrouter_workspaces.workspaces.workspaces[0].sid
  friendly_name = "[IVR Reporting] Workflow - Everyone"
  configuration = jsonencode({
    "task_routing" : {
      "filters" : [
        {
          "filter_friendly_name" : "Everyone",
          "expression" : "1==1",
          "targets" : [
            {
              "queue" : var.task_queue_everyone_sid
            }
          ]
        }
      ]
    }
  })
}
