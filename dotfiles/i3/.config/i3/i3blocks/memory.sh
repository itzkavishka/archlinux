#!/bin/bash
used=$(free -h | awk '/Mem:/ {print $3}')
avail=$(free -h | awk '/Mem:/ {print $7}')
echo "$used|$avail"
