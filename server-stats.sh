#!/bin/bash
echo -e "\n-------------------------"
echo -e "Server Performance Stats:"
echo -e "-------------------------"

# OS version
os_version=$(grep -E '^(VERSION|NAME)=' /etc/os-release)
echo -e "\nOS version: "
echo "$os_version"

# Uptime
server_uptime=$(uptime -p)
echo -e "\nUptime: "
echo "$server_uptime"

# Load average
load_average=$(cat /proc/loadavg)
echo -e "\nLoad average: "
echo "$load_average"

# Logged in users
logged_users=$(who)
echo -e "\nLogged in users: "
if [ -z "$logged_users" ]; then
    echo "No users currently logged in."
else
    echo "$logged_users"
fi

# Failed login attempts
failed_logins=$(journalctl -u sshd -b | grep "Failed password")
echo -e "\nFailed login attempts: "
if [ -z "$failed_logins" ]; then
    echo "No failed login attempts detected."
else
    echo "$failed_logins"
fi

# Total CPU usage
total_cpu_usage=$(top -bn2 | grep "Cpu(s)" | tail -n1 | sed 's/.*, *\([0-9.]*\)%* id.*/\1/' | awk '{ printf("%.1f%%", 100 - $1) }')
echo -e "\nTotal CPU usage: "
echo "$total_cpu_usage"

# Total memory usage (Free vs Used including percentage)
total_memory_usage=$(free -m | awk '/Mem:/ {
total=$2; used=$3; free=$4;
printf("Total: %dMB (%.1f%% used)\nUsed: %dMB\nFree: %dMB", total, used/total * 100, used, free) 
}')
echo -e "\nTotal memory usage: "
echo "$total_memory_usage"

# Total disk usage (Free vs Used including percentage)
total_disk_usage=$(df -BM / | awk 'NR==2 {
total=$2; used=$3; free=$4;
printf("Total: %dMB (%.1f%% used)\nUsed: %dMB\nFree: %dMB", total, used/total * 100, used, free)
}')
echo -e "\nTotal disk usage: "
echo "$total_disk_usage"

# Top 5 processes by CPU usage
top_proc_by_cpu_usage=$(ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 6)
echo -e "\nTop 5 processes by CPU usage: "
echo "$top_proc_by_cpu_usage"

# Top 5 processes by memory usage
top_proc_by_mem_usage=$(ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 6)
echo -e "\nTop 5 processes by memory usage: "
echo "$top_proc_by_mem_usage"