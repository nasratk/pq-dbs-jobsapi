let
    // Retrieve jobRunID from Excel table or named range
    Source = Excel.CurrentWorkbook(){[Name="JobRunIDTable"]}[Content],
    jobRunID = Source{0}[jobRunID],  // Extract the jobRunID

    // API to check job status
    url = rootUrl & "/api/2.1/jobs/runs/get?run_id=" & jobRunID,
    headers = [
        Authorization = "Bearer <your PAT here>"
    ],
    response = Json.Document(Web.Contents(url, [Headers = headers])),

    // Extract status and completion time
    lifeCycleStatus = response[state][life_cycle_state],
    resultStatus = if Record.HasFields(response, "result_state") then response[result_state] else "IN_PROGRESS",
    endTime = if Record.HasFields(response, "end_time") then DateTime.FromBinary(response[end_time]) else null,

    // Output the status and timestamp
    statusTable = Table.FromRecords({
        [jobRunID = jobRunID, status = resultStatus, completion_time = endTime]
    })
in
    statusTable