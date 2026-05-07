#!/bin/bash
# Inicia el servidor MCP SSE cada vez que el Codespace arranca
cd /workspaces/roblox-avatar-studio/mcp-servers
npm start &
echo "🔌 MCP SSE Server iniciado en puerto 3000"

# Iniciar Xvfb si no está corriendo
if ! pgrep -x Xvfb > /dev/null; then
  Xvfb :1 -screen 0 1280x800x16 &
  echo "🖥️ Xvfb iniciado"
fi
