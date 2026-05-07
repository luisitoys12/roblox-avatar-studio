/**
 * MCP SSE Bridge para Roblox Avatar Studio
 * Expone el Blender MCP (TCP socket :9876) como Server-Sent Events HTTP
 * URL de acceso: https://<codespace>-3000.app.github.dev/sse
 */
const express = require('express');
const cors = require('cors');
const net = require('net');

const app = express();
const PORT = 3000;
const BLENDER_MCP_HOST = '127.0.0.1';
const BLENDER_MCP_PORT = 9876;

app.use(cors({
  origin: '*',
  methods: ['GET', 'POST', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization', 'Accept']
}));
app.use(express.json());

// --- Health check ---
app.get('/health', (req, res) => {
  res.json({
    status: 'ok',
    service: 'Roblox Avatar Studio MCP Bridge',
    blender_mcp_port: BLENDER_MCP_PORT,
    timestamp: new Date().toISOString()
  });
});

// --- SSE endpoint para clientes MCP (Perplexity, Claude, etc.) ---
app.get('/sse', (req, res) => {
  res.setHeader('Content-Type', 'text/event-stream');
  res.setHeader('Cache-Control', 'no-cache');
  res.setHeader('Connection', 'keep-alive');
  res.setHeader('Access-Control-Allow-Origin', '*');

  // Enviar estado inicial
  res.write(`data: ${JSON.stringify({ type: 'connected', message: 'MCP SSE Bridge activo', blender_ready: false })}\n\n`);

  // Verificar si Blender MCP está escuchando
  const checkBlender = () => {
    const testSocket = new net.Socket();
    testSocket.setTimeout(2000);
    testSocket.connect(BLENDER_MCP_PORT, BLENDER_MCP_HOST, () => {
      res.write(`data: ${JSON.stringify({ type: 'status', blender_ready: true, message: 'Blender MCP conectado ✅' })}\n\n`);
      testSocket.destroy();
    });
    testSocket.on('error', () => {
      res.write(`data: ${JSON.stringify({ type: 'status', blender_ready: false, message: 'Blender MCP no disponible - inicia el servidor en Blender' })}\n\n`);
      testSocket.destroy();
    });
  };

  checkBlender();
  const interval = setInterval(checkBlender, 10000);

  req.on('close', () => {
    clearInterval(interval);
  });
});

// --- Proxy de comandos MCP a Blender ---
app.post('/mcp/execute', (req, res) => {
  const { command, params } = req.body;

  if (!command) {
    return res.status(400).json({ error: 'command requerido' });
  }

  const socket = new net.Socket();
  socket.setTimeout(30000);

  socket.connect(BLENDER_MCP_PORT, BLENDER_MCP_HOST, () => {
    const payload = JSON.stringify({ command, params: params || {} }) + '\n';
    socket.write(payload);
  });

  let responseData = '';
  socket.on('data', (data) => {
    responseData += data.toString();
    // Intentar parsear respuesta completa
    try {
      const parsed = JSON.parse(responseData);
      res.json({ success: true, result: parsed });
      socket.destroy();
    } catch (e) {
      // Continuar recibiendo datos
    }
  });

  socket.on('timeout', () => {
    res.status(504).json({ error: 'Timeout esperando respuesta de Blender' });
    socket.destroy();
  });

  socket.on('error', (err) => {
    res.status(503).json({
      error: 'No se puede conectar con Blender MCP',
      detail: 'Asegúrate de que el addon está activo en Blender (panel N > BlenderMCP > Start Server)',
      raw: err.message
    });
  });
});

// --- Información del workspace ---
app.get('/info', (req, res) => {
  res.json({
    name: 'Roblox Avatar Studio MCP Bridge',
    version: '1.0.0',
    description: 'Crea assets 3D para Roblox avatars usando IA + Blender',
    endpoints: {
      sse: '/sse - SSE stream para clientes MCP',
      execute: 'POST /mcp/execute - Ejecuta comandos en Blender',
      health: '/health - Estado del servicio'
    },
    how_to_use: [
      '1. Abre el desktop VNC en el puerto 6080',
      '2. Abre Blender desde el escritorio',
      '3. Presiona N > BlenderMCP > Start MCP Server',
      '4. Usa la URL SSE en Claude/Perplexity como MCP endpoint',
      '5. Habla con la IA para crear modelos 3D'
    ]
  });
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`🔌 MCP SSE Bridge corriendo en puerto ${PORT}`);
  console.log(`📡 SSE endpoint: http://localhost:${PORT}/sse`);
  console.log(`🔧 Execute endpoint: http://localhost:${PORT}/mcp/execute`);
  console.log(`ℹ️  Info: http://localhost:${PORT}/info`);
});
