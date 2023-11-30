#!/bin/bash

# Set the command you want to run
command_to_run="truffle test"

# Set the number of times to run the command
num_iterations=1

# Set the sleep duration in seconds
sleep_duration=1

# Loop to run the command multiple times
for ((i = 0; i < num_iterations; i++)); do
    echo "Running iteration $i: $command_to_run"
    $command_to_run

    if [ $i -lt $num_iterations ]; then
        echo "Sleeping for $sleep_duration seconds before the next iteration."
        sleep $sleep_duration
    fi
done

echo "Script completed."
