let
    // API to submit the notebook job
    url = rootUrl & "/api/2.1/jobs/runs/submit",
    headers = [
        Authorization = "Bearer <your PAT here>",
        #"Content-Type" = "application/json"
    ],

    // update the parameters below as required
    body = Text.ToBinary(
        "{
            ""run_name"": ""Power Query Job"",
            ""existing_cluster_id"": ""<YOUR_CLUSTER_ID>"",
            ""notebook_task"": {
                ""notebook_path"": ""/Users/your.email@your_domain.com/your_notebook"",
                ""base_parameters"": {
                    ""sql_query"": ""SELECT * FROM your_table LIMIT 10""
                }
            }
        }"
    ),
    response = Json.Document(Web.Contents(url, [Headers = headers, Content = body])),
    jobRunId = Text.From(response[run_id])
in
    Table.FromRecords({[jobRunID = jobRunId]})