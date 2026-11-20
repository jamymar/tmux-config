#!/usr/bin/env bash

# Affiche les statistiques de la première GPU NVIDIA
# Compatible avec les serveurs Linux et conteneurs GPU

if ! command -v nvidia-smi >/dev/null 2>&1; then
  exit 0
fi

gpu_data=$(nvidia-smi \
  --query-gpu=utilization.gpu,memory.used,memory.total,temperature.gpu \
  --format=csv,noheader,nounits \
  -i 0 2>/dev/null | head -n 1)

if [ -z "$gpu_data" ]; then
  exit 0
fi

IFS=',' read -r util used total temp <<< "$gpu_data"

# Retirer les espaces
util="${util// /}"
used="${used// /}"
total="${total// /}"
temp="${temp// /}"

if [[ "$total" =~ ^[0-9]+$ ]] && (( total > 0 )); then
  vram_percent=$((used * 100 / total))
else
  vram_percent="?"
fi

printf 'GPU %s%% | VRAM %s/%s MiB (%s%%) | %s°C' \
  "$util" "$used" "$total" "$vram_percent" "$temp"
