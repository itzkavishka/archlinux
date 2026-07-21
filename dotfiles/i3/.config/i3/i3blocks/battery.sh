#!/bin/bash

acpi_output=$(acpi -b)
percentage=$(echo "$acpi_output" | awk -F', ' '{print $2}')
time_remaining=$(echo "$acpi_output" | awk -F', ' '{print $3}' | sed 's/remaining//')

# Output just percentage and time remaining
echo "$percentage $time_remaining"