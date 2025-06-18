#!/bin/bash

# RPC Null Session Checker
#
# This script reads a list of target hosts from a file and attempts to
# connect to the RPC service (port 135) on each one using a null session
# (no username or password). It then tries to run a simple command ('srvinfo')
# to confirm the session is active.
#
# Usage:
# 1. Save this script as a file, e.g., check_rpc.sh
# 2. Make it executable: chmod +x check_rpc.sh
# 3. Ensure your target list (e.g., rpc.txt) exists.
# 4. Run the script: ./check_rpc.sh rpc.txt

# --- Configuration ---
# Timeout for the connection attempt in seconds
TIMEOUT=10

# --- Color Codes for Output ---
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# --- Prerequisite Check ---
# Check if the required tool 'rpcclient' is installed.
if ! command -v rpcclient &> /dev/null
then
    echo -e "${RED}[!] 'rpcclient' command not found.${NC}"
    echo "Please install it first. On Kali/Debian/Ubuntu, it's part of the 'smbclient' package:"
    echo "sudo apt update && sudo apt install -y smbclient"
    exit 1
fi

# Check if a target file was provided as an argument.
if [ -z "$1" ]; then
    echo "Usage: $0 <target_file>"
    echo "Example: $0 rpc.txt"
    exit 1
fi

TARGET_FILE="$1"

# Check if the target file exists.
if [ ! -f "$TARGET_FILE" ]; then
    echo -e "${RED}[!] Target file not found: $TARGET_FILE${NC}"
    exit 1
fi

# --- Main Script Logic ---
echo "[*] Starting RPC null session check on hosts from '$TARGET_FILE'..."
echo "----------------------------------------------------"

# Read each host from the provided file line by line.
while IFS= read -r host || [[ -n "$host" ]]; do
    # Skip empty lines
    if [ -z "$host" ]; then
        continue
    fi

    echo -ne "[*] Testing host: $host ... "

    # Attempt to connect with a null session and run a simple, non-disruptive command.
    # We redirect all output to /dev/null and check the exit code.
    # An exit code of 0 means the command was successful.
    if timeout "$TIMEOUT" rpcclient -U "" -N -c "srvinfo" "$host" &>/dev/null; then
        echo -e "${GREEN}SUCCESS! Null session is allowed.${NC}"
    else
        echo -e "${RED}FAILED. Null session is not allowed or host is down.${NC}"
    fi
done < "$TARGET_FILE"

echo "----------------------------------------------------"
echo "[*] RPC check completed."
