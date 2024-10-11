#!/bin/bash

# Determine the path to Node.js
NODE_PATH=$(which node)
if [ -z "$NODE_PATH" ]; then
  echo "Node.js is not installed. Please install Node.js and try again."
  exit 1
fi

# Determine the full path to the project directory
PROJECT_PATH=$(pwd)

# Ensure the index.js file exists
if [ ! -f "$PROJECT_PATH/index.js" ]; then
  echo "index.js not found in the current directory. Please navigate to the project directory and try again."
  exit 1
fi

# Create the random-time script
RANDOM_TIME_SCRIPT="$PROJECT_PATH/random-time-script.sh"

cat <<'EOF' > $RANDOM_TIME_SCRIPT
#!/bin/bash

# Calculate the random delay (between 0 and 5400 seconds, which is 1.5 hours)
start_time=$(date -d '02:30' +%s)
end_time=$(date -d '04:00' +%s)
range_seconds=$((end_time - start_time))

# Generate random seconds to delay
random_seconds=$(shuf -i 0-$range_seconds -n 1)

# Wait for the random time delay
sleep $random_seconds

# Run the Node.js script
$NODE_PATH $PROJECT_PATH/index.js
EOF

# Make the script executable
chmod +x $RANDOM_TIME_SCRIPT

# Add the cron job to run the random-time script every day at 2:30 AM UTC
CRON_JOB="30 2 * * * $RANDOM_TIME_SCRIPT"
(crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -

echo "Cron job added successfully. The bot will run at a random time between 2:30 AM and 4:00 AM UTC every day."
