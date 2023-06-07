exports.handler = async function (context, event, callback) {
  try {
    const client = context.getTwilioClient();

    // Debug: Console Log Incoming Events
    console.log("---Start of Raw Event: Update Task---");
    console.log(event);
    console.log("---End of Raw Event: Update Task---");

    // Step 1: Search for Task
    const IVR_end = new Date();
    const callStatus = event.callStatus;
    const digits = event.digits;
    const taskFilter = `conversations.conversation_id == '${event.callSid}'`;
    const getTask = await client.taskrouter
      .workspaces(context.TWILIO_WORKSPACE_SID)
      .tasks.list({ evaluateTaskAttributes: taskFilter });

    // Step 2: Process Task
    if (!getTask || !getTask[0] || !getTask[0].sid) {
      console.log(getTask);
      return callback("Unable to get task. Please check logs");
    }

    const taskSid = getTask[0].sid;
    let attributes = { ...JSON.parse(getTask[0].attributes) };
    const IVR_time = Math.round(
      (IVR_end - attributes.conversations.IVR_time_start) / 1000
    );

    attributes.conversations.queue_time = 0;
    attributes.conversations.ivr_time = IVR_time;

    // -- Appending IVR Path
    if (!attributes.conversations.ivr_path) {
      attributes.conversations.ivr_path = digits;
    } else {
      attributes.conversations.ivr_path += ` > ${digits}`;
    }

    // -- Check Abandon Call
    if (callStatus == "completed") {
      attributes.conversations.abandoned = "Yes";
      attributes.conversations.abandoned_phase = "IVR";
    } else {
      attributes.conversations.abandoned = "No";
      attributes.conversations.abandoned_phase = null;
    }

    // Step 3: Update Task
    let updateTaskPayload = {
      reason: "IVR task",
      attributes: JSON.stringify(attributes),
    };

    if (event.setTaskAssignmentStatus) {
      updateTaskPayload.assignmentStatus = event.setTaskAssignmentStatus;
    }
    const updateTaskResult = await client.taskrouter
      .workspaces(context.TWILIO_WORKSPACE_SID)
      .tasks(taskSid)
      .update(updateTaskPayload);

    console.log(updateTaskResult);

    return callback(null);
  } catch (err) {
    console.log(err);
    return callback("Unexpected Error: Please check logs");
  }
};
