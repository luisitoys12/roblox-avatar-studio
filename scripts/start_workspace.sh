#!/bin/bash
# Script de inicio rápido - ejecutar cuando abras el Codespace

export DISPLAY=:1

echo "🚀 Iniciando Roblox Avatar Studio workspace..."

# Iniciar servidor MCP SSE
echo "🔌 Iniciando MCP SSE Bridge (puerto 3000)..."
cd /workspaces/roblox-avatar-studio/mcp-servers
npm start &
MCP_PID=$!
echo "✅ MCP SSE PID: $MCP_PID"

# Iniciar Blender en modo background inicialmente
echo "🎨 Iniciando Blender..."
BLENDER_USER_DATA=$HOME/.config/blender blender &
BLENDER_PID=$!
echo "✅ Blender PID: $BLENDER_PID"

echo ""
echo "================================================"
echo "✅ Workspace iniciado"
echo "================================================"
echo "🖥️  VNC Desktop:    Puerto 6080"
echo "🎨 Blender MCP:    Puerto 9876  "
echo "🔌 MCP SSE URL:    Puerto 3000/sse"
echo "================================================"
echo "PRÓXIMOS PASOS:"
echo "1. Abre puerto 6080 (tab PORTS) → escritorio VNC"
echo "2. En Blender: panel N > BlenderMCP > Start Server"
echo "3. Copia la URL pública del puerto 3000 + /sse"
echo "4. Úsala como MCP endpoint en Claude o Perplexity"
echo "================================================"
