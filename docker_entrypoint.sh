#!/bin/sh

# Get total available memory in GB
total_memory_gb=$(awk '/MemAvailable/{print int($2 / 1024 / 1024)}' /proc/meminfo)

# Models list replacements based on memory size
if [ "$total_memory_gb" -gt 8 ]; then
    new_url="https://raw.githubusercontent.com/Start9Labs/serge-startos/weights/models-big.json"
else
    new_url="https://raw.githubusercontent.com/Start9Labs/serge-startos/weights/models-small.json"
fi

# Perform the sed command with the determined URL
#sed -i "s#https://raw.githubusercontent.com/serge-chat/serge/main/api/src/serge/data/models.json#$new_url#" /usr/src/app/api/static/_app/immutable/nodes/4.*.js

# Start Serge Chat
/usr/bin/dumb-init -- /bin/bash -c "/usr/src/app/deploy.sh" &

# Function to check if the URL is available
wait_for_url() {
    local url="$1"
    while ! curl -s --head --request GET "$url" | grep "405" > /dev/null; do
        sleep 1
    done
}

# Wait for the model URL to become available
wait_for_url "http://localhost:8008/api/model/refresh"

# Once the model URL is available, send the curl command
curl -X POST "http://localhost:8008/api/model/refresh" \
     -H "Content-Type: multipart/form-data" \
     -F "url=$new_url"
echo "$(date) - The curl command was executed" >> /usr/src/app/curl.txt

# Keep the script running to prevent it from exiting
while true; do
    sleep 1
done
