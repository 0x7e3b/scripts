# Define your API key here
$apiKey = "PLACE_API_KEY_HERE"

# Create the JSON payload for the request
$body = @{
    jsonrpc = "2.0"
    method = "generateIntegers"
    params = @{
        apiKey = $apiKey
        n = 2
        min = 0
        max = 255
        replacement = $true
    }
    id = 1
} | ConvertTo-Json

# Make the API request to Random.org
$response = Invoke-RestMethod -Uri "https://api.random.org/json-rpc/4/invoke" -Method Post -ContentType "application/json" -Body $body

# Extract the random numbers from the response
$random1 = $response.result.random.data[0]
$random2 = $response.result.random.data[1]

# Create the random /24 subnet
"10.$random1.$random2.254"
