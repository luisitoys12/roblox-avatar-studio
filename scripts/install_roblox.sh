#!/bin/bash
# Ejecutar este script DENTRO del desktop VNC (puerto 6080)
# Instala Roblox Studio via Wine

export WINEARCH=win64
export WINEPREFIX=/home/codespace/.wine64
export DISPLAY=:1

echo "🎮 Instalando Roblox Studio via Wine..."
cd /workspaces/roblox-avatar-studio/scripts

# Ejecutar el installer de Roblox Studio
wine RobloxStudioLauncherBeta.exe &

echo "⏳ El installer de Roblox Studio se abrirá en el escritorio VNC"
echo "📺 Accede al escritorio en: Puerto 6080 (pestaña PORTS en VS Code)"
echo "🔑 Password del VNC: robloxmcp"
