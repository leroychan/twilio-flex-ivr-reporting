exports.handler = async function (context, event, callback) {
  try {
    const client = context.getTwilioClient();

    // Debug: Console Log Incoming Events
    console.log("---Start of Raw Event: Create Task---");
    console.log(event);
    console.log("---End of Raw Event: Create Task---");

    // Step 1: Formulate Payload
    const timestamp = new Date();
    const from_number = event.from;
    let conversations = {};
    conversations.conversation_id = event.callSid;
    conversations.virtual = "Yes";
    conversations.abandoned = "Yes";
    conversations.abandoned_phase = "IVR";
    conversations.communication_channel = "IVR";
    conversations.IVR_time_start = timestamp.getTime();

    // Step 2: Create Task
    const createTaskResult = await client.taskrouter
      .workspaces(context.TWILIO_WORKSPACE_SID)
      .tasks.create({
        attributes: JSON.stringify({ from: from_number, conversations }),
        workflowSid: context.TWILIO_IVR_REPORTING_WORKFLOW_SID,
        timeout: 300,
      });

    if (!createTaskResult) {
      console.log(createTaskResult);
      return callback("Unable to Create Task. Please Check logs");
    }

    // Step 3: Return Payload
    console.log(createTaskResult);
    return callback(null, {
      success: true,
    });
  } catch (err) {
    console.log(err);
    return callback("Unexpected Error: Please check logs");
  }
};
