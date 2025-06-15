#!/bin/bash
echo -e "\n-------------------------"
echo -e "Server Performance Stats:"
echo -e "-------------------------"

# OS version
OS_VERSION=$(grep -E '^(VERSION|NAME)=' /etc/os-release)
echo -e "\nOS version: "
echo "$OS_VERSION"

# Uptime
SERVER_UPTIME=$(uptime -p)
echo -e "\nUptime: "
echo "$SERVER_UPTIME"

# Load average
LOAD_AVERAGE=$(cat /proc/loadavg)
echo -e "\nLoad average: "
echo "$LOAD_AVERAGE"

# Logged in users
LOGGED_USERS=$(who)
echo -e "\nLogged in users: "
if [ -z "$LOGGED_USERS" ]; then
    echo "No users currently logged in."
else
    echo "$LOGGED_USERS"
fi

# Failed login attempts
FAILED_LOGINS=$(journalctl -u sshd -b | grep "Failed password")
echo -e "\nFailed login attempts: "
if [ -z "$FAILED_LOGINS" ]; then
    echo "No failed login attempts detected."
else
    echo "$FAILED_LOGINS"
fi

# Total CPU usage
TOTAL_CPU_USAGE=$(top -bn2 | grep "Cpu(s)" | tail -n1 | sed 's/.*, *\([0-9.]*\)%* id.*/\1/' | awk '{ printf("%.1f%%", 100 - $1) }')
echo -e "\nTotal CPU usage: "
echo "$TOTAL_CPU_USAGE"

# Total memory usage (Free vs Used including percentage)
TOTAL_MEMORY_USAGE=$(free -m | awk '/Mem:/ {
total=$2; used=$3; free=$4;
printf("Total: %dMB (%.1f%% used)\nUsed: %dMB\nFree: %dMB", total, used/total * 100, used, free) 
}')
echo -e "\nTotal memory usage: "
echo "$TOTAL_MEMORY_USAGE"

# Total disk usage (Free vs Used including percentage)
TOTAL_DISK_USAGE=$(df -BM / | awk 'NR==2 {
total=$2; used=$3; free=$4;
printf("Total: %dMB (%.1f%% used)\nUsed: %dMB\nFree: %dMB", total, used/total * 100, used, free)
}')
echo -e "\nTotal disk usage: "
echo "$TOTAL_DISK_USAGE"

# Top 5 processes by CPU usage
TOP_PROC_BY_CPU_USAGE=$(ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 6)
echo -e "\nTop 5 processes by CPU usage: "
echo "$TOP_PROC_BY_CPU_USAGE"

# Top 5 processes by memory usage
TOP_PROC_BY_MEM_USAGE=$(ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 6)
echo -e "\nTop 5 processes by memory usage: "
echo "$TOP_PROC_BY_MEM_USAGE"