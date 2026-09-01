#!/bin/bash
while true; do
  name=$(grep 'model name' /proc/cpuinfo | head -1 | sed 's/^model name[[:space:]]*:[[:space:]]*//')
  cores=$(nproc)
  usage=$(top -bn1 | grep '%Cpu' | awk '{print 100-$8}')
  temps=$(sensors | grep 'k10temp' -A 2 | awk 'NR==3' | sed 's/^Tctl[[:space:]]*:[[:space:]]*//')
  printf '{"name":"%s","cores":"%s","usage":"%s","temp":"%s"}\n' "$name" "$cores" "$usage" "$temps"
  sleep 1
done
