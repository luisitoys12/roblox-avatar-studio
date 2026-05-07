#!/bin/bash
# Script de inicio completo - ejecutar cuando abras el Codespace
# Incluye keep-alive para evitar timeout de 30 minutos

export DISPLAY=:1
WS_DIR="/workspaces/roblox-avatar-studio"

echo "🚀 Iniciando Roblox Avatar Studio workspace..."

# --- Iniciar Xvfb (display virtual) ---
if ! pgrep -x Xvfb > /dev/null; then
  Xvfb :1 -screen 0 1280x800x16 &
  sleep 2
  echo "🖥️ Xvfb iniciado"
fi

# --- Iniciar servidor MCP SSE ---
echo "🔌 Iniciando MCP SSE Bridge (puerto 3000)..."
cd "$WS_DIR/mcp-servers"
if ! lsof -i:3000 > /dev/null 2>&1; then
  npm start > "$WS_DIR/mcp-sse.log" 2>&1 &
  sleep 2
  echo "✅ MCP SSE iniciado (PID: $!)"
else
  echo "ℹ️ MCP SSE ya estaba corriendo"
fi

# --- Keep-alive para evitar timeout de 30 min ---
echo "⏰ Iniciando keep-alive..."
if ! pgrep -f "keepalive.sh" > /dev/null; then
  bash "$WS_DIR/scripts/keepalive.sh" > /dev/null 2>&1 &
  echo "✅ Keep-alive iniciado (PID: $!)"
else
  echo "ℹ️ Keep-alive ya estaba corriendo"
fi

# --- Iniciar Blender en el escritorio virtual ---
echo "🎨 Iniciando Blender..."
if ! pgrep -x blender > /dev/null; then
  BLENDER_USER_DATA=$HOME/.config/blender blender > /dev/null 2>&1 &
  echo "✅ Blender iniciado (PID: $!)"
else
  echo "ℹ️ Blender ya estaba corriendo"
fi

# --- Guardar PIDs ---
echo $! > "$WS_DIR/.workspace_pids"

echo ""
echo "================================================"
echo "✅ Workspace listo"
echo "================================================"
echo "🖥️  VNC Desktop:     Puerto 6080"
echo "🎨 Blender MCP:     Puerto 9876"
echo "🔌 MCP SSE URL:     Puerto 3000/sse"
echo "⏰ Keep-alive:      ACTIVO (ping c/4 min)"
echo "================================================"
echo "PRÓXIMOS PASOS:"
echo "1. Abre puerto 6080 (tab PORTS) → escritorio VNC"
echo "2. En Blender: panel N > BlenderMCP > Start Server"
echo "3. Copia la URL pública del puerto 3000 + /sse"
echo "================================================"
