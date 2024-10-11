#!/bin/bash

# Define your API key here
API_KEY="PLACE_API_KEY_HERE"

# Generate two random numbers between 0 and 255 using Random.org
response=$(curl -s -X POST -H "Content-Type: application/json" -d '{
    "jsonrpc": "2.0",
    "method": "generateIntegers",
    "params": {
        "apiKey": "'"$API_KEY"'",
        "n": 2,
        "min": 0,
        "max": 255,
        "replacement": true
    },
    "id": 1
}' https://api.random.org/json-rpc/4/invoke)

# Extract the random numbers using jq
random1=$(echo "$response" | jq '.result.random.data[0]')
random2=$(echo "$response" | jq '.result.random.data[1]')

# Create the random /24 subnet
echo "10.$random1.$random2.254"
