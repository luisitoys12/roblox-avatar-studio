# ☁️ Alternativas Cloud para Roblox Avatar Studio — Pago por Uso

> Guía para cuando el Codespace gratuito no sea suficiente o necesites GPU dedicada para renders pesados en Blender.

---

## Por Qué Pago por Uso (no suscripción fija)

Las suscripciones mensuales fijas (Shadow PC, GeForce NOW) cobran aunque no uses el servicio. Para creación esporádica de assets UGC, el modelo **pago por hora** es siempre más económico — pagas solo los minutos que Blender o Roblox Studio están activos.

---

## Opciones Ordenadas por Costo

### 1. GitHub Codespaces — El Punto de Partida

**Modelo:** Pago por hora de cómputo utilizada  
**Precio:** $0.18/hr (2-core) · $0.36/hr (4-core) · $0.72/hr (8-core)  
**Gratis:** 120 core-hours/mes en cuentas free (= 60 hrs en máquina 4-core)  
**GPU:** ❌ Sin GPU dedicada  
**Ideal para:** Modelado con Blender Eevee, scripting, configuración

> ⚠️ Blender funciona en CPU rendering. Sin GPU, renders complejos tardan mucho. Para modelado y export .fbx es suficiente.

**Cómo detener para no gastar:**
```
github.com/codespaces → tu codespace → Stop codespace
```

---

### 2. Vast.ai — GPU por Hora (Recomendado para Renders)

**Modelo:** Marketplace de GPUs ociosas — pago por hora exacta  
**Precio típico:** $0.20–$0.60/hr por RTX 3090 · $0.40–$1.20/hr por RTX 4090  
**GPU:** ✅ GPU potente dedicada  
**OS:** Linux con Docker, instalar Blender manualmente  
**Pago:** Tarjeta o PayPal, depósito mínimo $10 USD  
**Ideal para:** Renders Cycles pesados, generación de texturas IA

**Setup rápido en Vast.ai:**
1. Crea cuenta en [vast.ai](https://vast.ai)
2. Busca instancia: `image: "pytorch/pytorch"` con GPU RTX 3090+
3. Selecciona y renta (On-Demand)
4. En la terminal SSH:
   ```bash
   apt-get install -y blender
   pip install blender-mcp
   ```
5. Forward el puerto 9876 para conectar MCP

**Costo estimado por sesión de trabajo (3 horas):** ~$1.20–$2.50 USD

---

### 3. RunPod — GPU Cloud Simple

**Modelo:** Pago por hora con pods configurables  
**Precio:** $0.19/hr (RTX 3080) · $0.44/hr (RTX 4090)  
**GPU:** ✅ Con GPU dedicada  
**OS:** Ubuntu con escritorio XFCE disponible (Pods con GUI)  
**Pago:** Tarjeta de crédito, mínimo $10 recarga  
**Ideal para:** Usuarios que quieren interfaz gráfica + GPU

**Template recomendado:** Busca `"Blender"` en los templates públicos de RunPod — ya tiene Blender preinstalado con VNC.

**URL de acceso:** RunPod genera una URL pública para el puerto VNC — accedes directo desde browser, igual que el Codespace.

**Costo estimado por sesión (3 horas):** ~$0.60–$1.50 USD

---

### 4. Paperspace Gradient — Notebooks + GPU

**Modelo:** Pago por hora o plan free con GPU limitada  
**Precio free:** GPU gratuita (M4000) con tiempos de espera · $0.45/hr (RTX 4000)  
**GPU:** ✅ Disponible  
**OS:** Jupyter notebooks / Linux  
**Ideal para:** Generación de modelos IA (Meshy, Stable Diffusion 3D) antes de importar a Blender

**Limitación:** No tiene escritorio gráfico nativo. Blender corre en modo headless o via Jupyter.

---

### 5. Shadow PC — Suscripción Mensual (Si Usas Diario)

**Modelo:** PC Windows completa en la nube — suscripción mensual  
**Precio:** ~$29.99 USD/mes (plan base, 12GB RAM, GTX 1080 equiv.)  
**GPU:** ✅ Dedicada  
**OS:** Windows completo — Roblox Studio nativo (sin Wine)  
**Pago:** Tarjeta, puede cancelarse mensualmente  
**Disponibilidad en MX:** Conecta desde México con latencia ~80-120ms (servidores Dallas/Chicago)  
**Ideal para:** Si creas assets UGC más de 20 horas al mes

> 💡 Shadow PC es la única opción que corre Roblox Studio **nativo en Windows** sin Wine, lo que elimina cualquier problema de compatibilidad.

**Acceso:** App de Shadow para Windows/Mac/iOS/Android, o browser.

---

## Comparativa Final

| Servicio | GPU | Precio/hr | Pago | Roblox Studio | Mejor para |
|----------|-----|-----------|------|---------------|------------|
| **GitHub Codespaces** | ❌ | $0.36 | Por hr | Wine (lento) | Modelado básico |
| **Vast.ai** | ✅ RTX 4090 | $0.40–1.20 | Por hr | Wine | Renders pesados |
| **RunPod** | ✅ RTX 3080 | $0.44 | Por hr | Wine con GUI | Uso intermedio |
| **Paperspace** | ✅ M4000 | Gratis/$0.45 | Por hr | ❌ | IA generativa |
| **Shadow PC** | ✅ GTX equiv | $1.00 (est.) | Mensual | ✅ Nativo | Uso diario |

---

## Recomendación por Etapa del Proyecto

**Fase 1 — Aprendizaje y pruebas (0–10 assets):**  
→ GitHub Codespaces gratuito. El Codespace de este repo ya está configurado.

**Fase 2 — Producción regular (10–50 assets/mes):**  
→ Vast.ai para renders + Codespace para modelado y Studio.  
Costo estimado: $5–15 USD/mes dependiendo de uso.

**Fase 3 — Producción intensiva (50+ assets, ingreso UGC):**  
→ Shadow PC como máquina principal.  
El ingreso del Marketplace debe cubrir los ~$30/mes.

---

## Tips de Ahorro

- **Siempre detén las instancias** cuando termines — Vast.ai y RunPod siguen cobrando si no las detienes
- **Guarda tu trabajo en GitHub** antes de destruir pods — usa `git push` desde la instancia
- **Usa el Codespace para todo lo que no requiera GPU** — es el más barato y ya está configurado
- **Roblox Studio en Wine** funciona para importar .fbx y configurar accesorios — no necesita GPU
- **El render final de tu escena** sí necesita GPU — hazlo solo en Vast.ai/RunPod

---

*Última actualización: Mayo 2026*
