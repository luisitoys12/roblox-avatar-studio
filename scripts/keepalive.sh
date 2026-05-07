#!/bin/bash
# ============================================
# KEEP-ALIVE para GitHub Codespace
# Evita el timeout de 30 minutos de inactividad
# Ejecutar en background: bash scripts/keepalive.sh &
# ============================================

echo "⏰ Keep-alive iniciado (ping cada 4 minutos)"
echo "PID: $$"
echo "Para detenerlo: kill $$"

WS_DIR="/workspaces/roblox-avatar-studio"
LOG_FILE="$WS_DIR/keepalive.log"

while true; do
  TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

  # 1. Simular actividad de filesystem (lo que detecta Codespace como "activo")
  touch "$WS_DIR/.keepalive_ping"

  # 2. Ping al SSE server local para mantener el proceso activo
  curl -s http://localhost:3000/health > /dev/null 2>&1 || true

  # 3. Log ligero para confirmar que sigue vivo
  echo "$TIMESTAMP - ping ok" >> "$LOG_FILE"

  # Mantener solo las últimas 100 líneas del log
  tail -n 100 "$LOG_FILE" > "$LOG_FILE.tmp" && mv "$LOG_FILE.tmp" "$LOG_FILE"

  # Esperar 4 minutos (240 segundos) - bien por debajo del timeout de 30min
  sleep 240
done
