# 🎮 Roblox Avatar Studio — Cloud Workspace

> Crea assets 3D para avatares de Roblox usando IA + Blender, todo en la nube. Sin PC potente necesaria.

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/luisitoys12/roblox-avatar-studio?quickstart=1)

---

## 🏗️ Arquitectura

```
Tu browser
    │
    ├──► Puerto 6080 → Desktop VNC (noVNC)
    │         ├── Blender 4.3.2 con MCP addon
    │         └── Roblox Studio (via Wine)
    │
    ├──► Puerto 3000 → MCP SSE Bridge
    │         └── Conecta Claude/Perplexity con Blender
    │
    └──► Puerto 9876 → Blender MCP Socket
```

---

## 🚀 Inicio Rápido

### 1. Abrir el Codespace

Haz click en el badge de arriba o ve a:
```
https://codespaces.new/luisitoys12/roblox-avatar-studio?quickstart=1
```

Selecciona **4-core machine** para mejor rendimiento.

### 2. Esperar el Setup Automático

El `postCreate.sh` instala automáticamente:
- ✅ Blender 4.3.2
- ✅ BlenderMCP addon + servidor Python
- ✅ Node.js MCP SSE Bridge
- ✅ Wine + Roblox Studio installer
- ✅ Claude Desktop config

Espera ~10 minutos en la primera creación.

### 3. Iniciar el Workspace

```bash
bash scripts/start_workspace.sh
```

### 4. Abrir el Desktop VNC

1. Ve a la pestaña **PORTS** en VS Code
2. Abre el puerto **6080** en el browser
3. Password: `robloxmcp`

### 5. Activar Blender MCP

1. En el desktop VNC, abre Blender
2. Presiona `N` para abrir el panel lateral
3. Ve a la pestaña **BlenderMCP**
4. Click en **Start MCP Server**

### 6. Obtener tu URL MCP SSE

En la pestaña PORTS de tu Codespace, el puerto `3000` tiene una URL pública así:
```
https://luisitoys12-refactored-barnacle-XXXXXXX-3000.app.github.dev/sse
```

Usa esa URL en Claude Desktop o cualquier cliente MCP.

---

## 🔌 Usar con Claude Desktop

Copia `mcp-servers/claude_desktop_config.json` a:
- **Linux/Mac**: `~/.config/Claude/claude_desktop_config.json`
- **Windows**: `%APPDATA%\Claude\claude_desktop_config.json`

Luego reinicia Claude Desktop.

---

## 🎨 Flujo de Creación de Assets Roblox

```
1. Describe el accesorio a Claude:
   "Crea un casco futurista de 800 polígonos para avatar Roblox R15"

2. Claude lo genera en Blender via MCP

3. En el desktop VNC, exporta desde Blender:
   File > Export > FBX (.fbx)
   Guarda en /workspaces/roblox-avatar-studio/assets/

4. Abre Roblox Studio (desde scripts/install_roblox.sh)

5. Importa el .fbx y usa la Accessory Fitting Tool

6. Publica al Marketplace desde Creator Hub
```

---

## 📁 Estructura del Proyecto

```
├── .devcontainer/
│   ├── devcontainer.json     # Config del Codespace
│   ├── postCreate.sh         # Instalación automática
│   └── postStart.sh          # Inicio automático
├── mcp-servers/
│   ├── sse-server.js         # MCP SSE Bridge
│   ├── package.json
│   └── claude_desktop_config.json
├── scripts/
│   ├── start_workspace.sh    # Inicio del workspace
│   ├── install_roblox.sh     # Instala Roblox Studio
│   └── enable_addon.py       # Activa addon Blender
├── assets/                   # Tus modelos .fbx, .blend
└── docs/
    └── shadow-pc-guide.md    # Alternativa Shadow PC
```

---

## 💰 Costos del Codespace

| Machine | CPU | RAM | Costo/hr | Ideal para |
|---------|-----|-----|----------|------------|
| 2-core  | 2   | 8GB | $0.18    | Solo código |
| **4-core** | **4** | **16GB** | **$0.36** | **Recomendado** |
| 8-core  | 8   | 32GB | $0.72   | Renders pesados |

**Plan Free GitHub:** 120 horas core/mes gratis (= 60 hrs en 4-core)
**Después:** $0.36 USD/hr — detén el Codespace cuando no lo uses.

> ⚠️ Siempre detén el Codespace desde: github.com/codespaces → Stop

---

## 🆘 Troubleshooting

**Blender no conecta con MCP:**
```bash
# Verifica que el servidor esté activo
netstat -tlnp | grep 9876
```

**Puerto 6080 no carga:**
```bash
# Reinicia el servidor VNC
bash .devcontainer/postStart.sh
```

**Wine / Roblox Studio lento:**
- Upgrade a máquina de 8-core temporalmente
- O considera Shadow PC (ver docs/shadow-pc-guide.md)
