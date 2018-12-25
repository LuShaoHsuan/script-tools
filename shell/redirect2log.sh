#!/bin/sh

# log file location
SCRIPT_FILE="<script path>"
LOG_FILE="<log file path>"

# redirect stdout to log file and console
${SCRIPT_FILE} 2>&1 | tee ${LOG_FILE}