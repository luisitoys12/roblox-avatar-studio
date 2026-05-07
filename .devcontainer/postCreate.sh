#!/bin/bash
set -e

echo "================================================"
echo "🚀 Roblox Avatar Studio - Cloud Setup"
echo "================================================"

# --- Sistema base ---
sudo apt-get update -qq
sudo apt-get install -y -qq \
  wget curl git unzip xvfb \
  libxi6 libxxf86vm1 libxfixes3 libxrender1 \
  libgl1-mesa-glx libglu1-mesa \
  libsm6 libice6 \
  python3-pip python3-venv \
  wine64 winetricks \
  cabextract \
  2>/dev/null

echo "✅ Dependencias del sistema instaladas"

# --- Blender 4.3.2 ---
echo "📦 Descargando Blender 4.3.2..."
cd /tmp
wget -q https://download.blender.org/release/Blender4.3/blender-4.3.2-linux-x64.tar.xz
tar -xf blender-4.3.2-linux-x64.tar.xz
sudo mv blender-4.3.2-linux-x64 /opt/blender
sudo ln -sf /opt/blender/blender /usr/local/bin/blender
rm blender-4.3.2-linux-x64.tar.xz
echo "✅ Blender instalado en /opt/blender"

# --- Python uv (para MCP servers) ---
echo "📦 Instalando uv (Python package manager)..."
curl -LsSf https://astral.sh/uv/install.sh | sh
export PATH="$HOME/.local/bin:$PATH"
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
echo "✅ uv instalado"

# --- Blender MCP server (Python) ---
echo "📦 Instalando blender-mcp..."
pip install blender-mcp --quiet
echo "✅ blender-mcp instalado"

# --- Node.js MCP SSE Bridge ---
echo "📦 Instalando dependencias Node.js del SSE bridge..."
cd /workspaces/roblox-avatar-studio/mcp-servers
npm install --silent
echo "✅ MCP SSE Bridge listo"

# --- Addon de Blender MCP ---
echo "📦 Instalando addon Blender MCP..."
BLENDER_ADDON_DIR="/root/.config/blender/4.3/scripts/addons"
mkdir -p "$BLENDER_ADDON_DIR"
cd /tmp
wget -q https://github.com/ahujasid/blender-mcp/raw/main/addon.py -O blender_mcp_addon.py
cp blender_mcp_addon.py "$BLENDER_ADDON_DIR/blender_mcp_addon.py"

# Habilitar addon via script Python de Blender
blender --background --python /workspaces/roblox-avatar-studio/scripts/enable_addon.py 2>/dev/null || true
echo "✅ Addon Blender MCP instalado"

# --- Wine para Roblox Studio ---
echo "🍷 Configurando Wine para Roblox Studio..."
export WINEARCH=win64
export WINEPREFIX=/home/codespace/.wine64
wineboot --init 2>/dev/null || true
winetricks -q dotnet48 vcrun2022 2>/dev/null || true
echo "⏳ Descargando Roblox Studio installer..."
wget -q https://setup.rbxcdn.com/RobloxStudioLauncherBeta.exe -O /tmp/RobloxStudioLauncherBeta.exe
echo "✅ Roblox Studio installer descargado (ejecutar manualmente en el escritorio VNC)"
cp /tmp/RobloxStudioLauncherBeta.exe /workspaces/roblox-avatar-studio/scripts/

# --- Claude Desktop config ---
echo "⚙️ Configurando Claude Desktop MCP config..."
mkdir -p /root/.config/Claude
cp /workspaces/roblox-avatar-studio/mcp-servers/claude_desktop_config.json /root/.config/Claude/claude_desktop_config.json
echo "✅ Claude Desktop configurado"

echo ""
echo "================================================"
echo "✅ SETUP COMPLETADO"
echo "================================================"
echo "📺 Desktop VNC: Puerto 6080 (abre en PORTS tab)"
echo "🎨 Blender MCP: Puerto 9876"
echo "🔌 MCP SSE: Puerto 3000"
echo "📋 Instalar Roblox Studio: corre scripts/install_roblox.sh en el desktop VNC"
echo "================================================"
