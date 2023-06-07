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

data "twilio_taskrouter_task_channel" "voice_task_channel" {
  workspace_sid = data.twilio_taskrouter_workspaces.workspaces.workspaces[0].sid
  unique_name   = "Voice"
}

resource "twilio_studio_flow" "flow" {
  friendly_name = "[IVR Reporting] Studio Flow"
  status        = "published"
  definition = jsonencode({
    "description" : "Studio Flow for IVR Reporting",
    "states" : [
      {
        "name" : "Trigger",
        "type" : "trigger",
        "transitions" : [
          {
            "event" : "incomingMessage"
          },
          {
            "next" : "function_create_task",
            "event" : "incomingCall"
          },
          {
            "event" : "incomingConversationMessage"
          },
          {
            "event" : "incomingRequest"
          },
          {
            "event" : "incomingParent"
          }
        ],
        "properties" : {
          "offset" : {
            "x" : 0,
            "y" : 0
          }
        }
      },
      {
        "name" : "function_create_task",
        "type" : "run-function",
        "transitions" : [
          {
            "next" : "gather_input",
            "event" : "success"
          },
          {
            "event" : "fail"
          }
        ],
        "properties" : {
          "service_sid" : var.function_task_service_sid,
          "environment_sid" : var.function_task_environment_sid,
          "offset" : {
            "x" : 140,
            "y" : 200
          },
          "function_sid" : var.function_task_create_function_sid,
          "parameters" : [
            {
              "value" : "{{trigger.call.Caller}}",
              "key" : "from"
            },
            {
              "value" : "{{trigger.call.CallSid}}",
              "key" : "callSid"
            }
          ],
          "url" : var.function_create_task_url
        }
      },
      {
        "name" : "gather_input",
        "type" : "gather-input-on-call",
        "transitions" : [
          {
            "next" : "function_update_task_1",
            "event" : "keypress"
          },
          {
            "event" : "speech"
          },
          {
            "event" : "timeout"
          }
        ],
        "properties" : {
          "voice" : "alice",
          "speech_timeout" : "auto",
          "offset" : {
            "x" : 150,
            "y" : 450
          },
          "loop" : 1,
          "finish_on_key" : "#",
          "say" : "Hello, welcome to IVR reporting demo. Please press 1 for Sales and press 2 for customer support",
          "language" : "en-US",
          "stop_gather" : true,
          "gather_language" : "en",
          "profanity_filter" : "true",
          "timeout" : 5
        }
      },
      {
        "name" : "gather_2",
        "type" : "gather-input-on-call",
        "transitions" : [
          {
            "next" : "function_update_task_2",
            "event" : "keypress"
          },
          {
            "event" : "speech"
          },
          {
            "event" : "timeout"
          }
        ],
        "properties" : {
          "voice" : "alice",
          "speech_timeout" : "auto",
          "offset" : {
            "x" : -160,
            "y" : 1240
          },
          "loop" : 1,
          "finish_on_key" : "#",
          "say" : "Welcome to the sales team. Please press 1 for credit card enquiry and press 2 for loan enquiry",
          "language" : "en-US",
          "stop_gather" : true,
          "gather_language" : "en",
          "profanity_filter" : "true",
          "timeout" : 5
        }
      },
      {
        "name" : "gather_3",
        "type" : "gather-input-on-call",
        "transitions" : [
          {
            "next" : "function_update_task_3",
            "event" : "keypress"
          },
          {
            "event" : "speech"
          },
          {
            "event" : "timeout"
          }
        ],
        "properties" : {
          "voice" : "alice",
          "speech_timeout" : "auto",
          "offset" : {
            "x" : 500,
            "y" : 1230
          },
          "loop" : 1,
          "finish_on_key" : "#",
          "say" : "Welcome to support team. Please press 1 for mobile app support and press 2 for all other enquiries",
          "language" : "en-US",
          "stop_gather" : true,
          "gather_language" : "en",
          "profanity_filter" : "true",
          "timeout" : 5
        }
      },
      {
        "name" : "split_1",
        "type" : "split-based-on",
        "transitions" : [
          {
            "event" : "noMatch"
          },
          {
            "next" : "gather_2",
            "event" : "match",
            "conditions" : [
              {
                "friendly_name" : "If value equal_to 1",
                "arguments" : [
                  "{{widgets.gather_input.Digits}}"
                ],
                "type" : "equal_to",
                "value" : "1"
              }
            ]
          },
          {
            "next" : "gather_3",
            "event" : "match",
            "conditions" : [
              {
                "friendly_name" : "If value equal_to 2",
                "arguments" : [
                  "{{widgets.gather_input.Digits}}"
                ],
                "type" : "equal_to",
                "value" : "2"
              }
            ]
          }
        ],
        "properties" : {
          "input" : "{{widgets.gather_input.Digits}}",
          "offset" : {
            "x" : 140,
            "y" : 940
          }
        }
      },
      {
        "name" : "function_update_task_1",
        "type" : "run-function",
        "transitions" : [
          {
            "next" : "split_1",
            "event" : "success"
          },
          {
            "event" : "fail"
          }
        ],
        "properties" : {
          "service_sid" : var.function_task_service_sid,
          "environment_sid" : var.function_task_environment_sid,
          "offset" : {
            "x" : 140,
            "y" : 700
          },
          "function_sid" : var.function_task_update_function_sid,
          "parameters" : [
            {
              "value" : "{{trigger.call.CallSid}}",
              "key" : "callSid"
            },
            {
              "value" : "{{widgets.gather_input.Digits}}",
              "key" : "digits"
            },
            {
              "value" : "{{widgets.gather_input.CallStatus}}",
              "key" : "callStatus"
            }
          ],
          "url" : var.function_update_task_url
        }
      },
      {
        "name" : "function_update_task_2",
        "type" : "run-function",
        "transitions" : [
          {
            "next" : "send_to_flex_1",
            "event" : "success"
          },
          {
            "event" : "fail"
          }
        ],
        "properties" : {
          "service_sid" : var.function_task_service_sid,
          "environment_sid" : var.function_task_environment_sid,
          "offset" : {
            "x" : -160,
            "y" : 1540
          },
          "function_sid" : var.function_task_update_function_sid,
          "parameters" : [
            {
              "value" : "{{trigger.call.CallSid}}",
              "key" : "callSid"
            },
            {
              "value" : "{{widgets.gather_2.Digits}}",
              "key" : "digits"
            },
            {
              "value" : "{{widgets.gather_input.CallStatus}}",
              "key" : "callStatus"
            },
            {
              "value" : "canceled",
              "key" : "setTaskAssignmentStatus"
            }
          ],
          "url" : var.function_update_task_url
        }
      },
      {
        "name" : "function_update_task_3",
        "type" : "run-function",
        "transitions" : [
          {
            "next" : "send_to_flex_1",
            "event" : "success"
          },
          {
            "event" : "fail"
          }
        ],
        "properties" : {
          "service_sid" : var.function_task_service_sid,
          "environment_sid" : var.function_task_environment_sid,
          "offset" : {
            "x" : 500,
            "y" : 1540
          },
          "function_sid" : var.function_task_update_function_sid,
          "parameters" : [
            {
              "value" : "{{trigger.call.CallSid}}",
              "key" : "callSid"
            },
            {
              "value" : "{{widgets.gather_3.Digits}}",
              "key" : "digits"
            },
            {
              "value" : "{{widgets.gather_input.CallStatus}}",
              "key" : "callStatus"
            },
            {
              "value" : "canceled",
              "key" : "setTaskAssignmentStatus"
            }
          ],
          "url" : var.function_update_task_url
        }
      },
      {
        "name" : "send_to_flex_1",
        "type" : "send-to-flex",
        "transitions" : [
          {
            "event" : "callComplete"
          },
          {
            "event" : "failedToEnqueue"
          },
          {
            "event" : "callFailure"
          }
        ],
        "properties" : {
          "offset" : {
            "x" : 160,
            "y" : 1870
          },
          "workflow" : var.workflows_everyone_sid,
          "channel" : data.twilio_taskrouter_task_channel.voice_task_channel.sid,
          "attributes" : "{ \"conversations\": { \"conversation_id\": \"{{trigger.call.CallSid}}\"}}"
        }
      }
    ],
    "initial_state" : "Trigger",
    "flags" : {
      "allow_concurrent_calls" : true
    }
  })
  validate = true
}
