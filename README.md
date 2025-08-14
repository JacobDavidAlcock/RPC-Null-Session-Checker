# RPC Null Session Checker

A lightweight Bash script for penetration testers and system administrators to quickly scan a list of hosts for the presence of an anonymous RPC null session vulnerability. This script automates the process of checking if a Windows host allows unauthenticated users to connect to its RPC endpoint and enumerate information.

## Features

- **Bulk Scanning**: Efficiently reads a list of target hosts from a specified file.
- **Null Session Test**: Specifically checks if an anonymous connection (`-U "" -N`) can be established.
- **Safe & Non-disruptive**: Verifies the connection by running a simple, read-only command (`srvinfo`) that does not alter the target system.
- **Color-Coded Output**: Provides clear, color-coded terminal output for easy identification of `SUCCESS` (vulnerable) versus `FAILED` (not vulnerable) hosts.
- **Lightweight & Fast**: A simple Bash script with minimal dependencies, making it fast and portable for use during security assessments.
- **Configurable**: Easily change the connection timeout within the script.

## Prerequisites

Before running this script, you need to have the following tool installed:

- `rpcclient`: A command-line utility for interacting with RPC services.

### Installing `rpcclient`

On Debian-based systems like Kali Linux or Ubuntu, `rpcclient` is part of the `smbclient` package. You can install it easily with `apt`:

```bash
sudo apt update && sudo apt install -y smbclient
```

## Installation & Usage

### 1. Clone the Repository

```bash
[git clone https://github.com/JacobDavidAlcock/rpc-null-checker.git](https://github.com/JacobDavidAlcock/RPC-Null-Session-Checker.git)
cd rpc-null-checker
```

### 2. Make the Script Executable

```bash
chmod +x check_rpc.sh
```

### 3. Create Your Target File

Create a text file (e.g., `targets.txt`) and populate it with the IP addresses or hostnames you want to scan, one per line.

```
192.168.1.10
192.168.1.15
STCDC01.domain.local
```

### 4. Run the Script

Execute the script and provide your target file as an argument:

```bash
./check_rpc.sh targets.txt
```

The script will report which hosts are vulnerable to an RPC null session connection. Once a vulnerable host is identified, you can connect to it manually (`rpcclient -U "" -N <IP>`) to enumerate further information using commands like `enumdomusers`, `enumdomgroups`, etc.

## Disclaimer

This tool is intended for use in authorized security testing and network administration scenarios only. Unauthorized scanning of networks is illegal. The user is responsible for ensuring they have explicit, written permission to test any targets. The author is not responsible for any misuse or damage caused by this script.

## License

This project is licensed under the MIT License.
