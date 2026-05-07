#!/bin/bash
# Auto-ejecutado cada vez que el Codespace ARRANCA (no solo al crear)

export DISPLAY=:1
WS_DIR="/workspaces/roblox-avatar-studio"

# Esperar que el filesystem esté listo
sleep 3

# Iniciar Xvfb
if ! pgrep -x Xvfb > /dev/null; then
  Xvfb :1 -screen 0 1280x800x16 &
  sleep 2
fi

# Iniciar MCP SSE bridge
cd "$WS_DIR/mcp-servers"
if ! lsof -i:3000 > /dev/null 2>&1; then
  npm start > "$WS_DIR/mcp-sse.log" 2>&1 &
fi

# Iniciar keep-alive SIEMPRE al arrancar
if ! pgrep -f "keepalive.sh" > /dev/null; then
  bash "$WS_DIR/scripts/keepalive.sh" > /dev/null 2>&1 &
fi

echo "✅ postStart completado - keep-alive activo"
