#!/bin/bash

# Request a random number from random.org within the hex range using curl
random_hex=$(curl -s "https://www.random.org/integers/?num=1&min=0&max=65535&col=1&base=16&format=plain&rnd=new")

# Display the result with formatting to ensure it's always 4 digits in lowercase
printf "%04x\n" "0x$random_hex"
