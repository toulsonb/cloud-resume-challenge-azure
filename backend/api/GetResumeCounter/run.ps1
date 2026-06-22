param($Request, $inputDocument, $TriggerMetadata)

# 1. Increment the database visitor count value
$inputDocument.count += 1

# 2. Sync the modifications to the database layer
Push-OutputBinding -Name outputDocument -Value $inputDocument

# 3. Serve the result payload back to the client interface
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = 200
    Body = @{ count = $inputDocument.count }
    Headers = @{
        "Content-Type" = "application/json"
        "Access-Control-Allow-Origin" = "*"  # Cross-Origin Resource Sharing security mapping
    }
})