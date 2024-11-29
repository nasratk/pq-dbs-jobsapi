let
    // Retrieve jobRunID from Excel table or named range
    Source = Excel.CurrentWorkbook(){[Name="JobRunIDTable"]}[Content],
    jobRunID = Source{0}[jobRunID],

    // API to get the job output
    outputUrl = rootUrl & "/api/2.1/jobs/runs/get-output?run_id=" & jobRunID,
    headers = [
        Authorization = "Bearer <your PAT here>"
    ],
    outputResponse = Json.Document(Web.Contents(outputUrl, [Headers = headers])),

    // Extract the CSV path
    csvPath = outputResponse[notebook_output][result],

    // API to download the CSV file
    dbfsReadUrl = rootUrl & "/api/2.0/dbfs/read?path=" & csvPath,
    csvResponse = Web.Contents(dbfsReadUrl, [Headers = headers]),
    csvContent = Binary.FromText(Json.Document(csvResponse)[data], BinaryEncoding.Base64),
    csvTable = Csv.Document(csvContent, [Delimiter=",", Encoding=65001, QuoteStyle=QuoteStyle.Csv])
in
    csvTable