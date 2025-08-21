# ComfyUI en Jupyter — Guía Completa

> **Interfaz web de ComfyUI accesible vía proxy de Jupyter para generación de imágenes con IA**

## 📋 Tabla de Contenidos

- [🚀 Instalación Rápida](#-instalación-rápida)
- [📁 Estructura del Proyecto](#-estructura-del-proyecto)
- [⚙️ Configuración](#️-configuración)
- [🎯 Casos de Uso](#-casos-de-uso)
- [🔧 Nodos Personalizados](#-nodos-personalizados)
- [🔄 Actualización](#-actualización)
- [🌐 Acceso Web](#-acceso-web)
- [🛠️ Solución de Problemas](#️-solución-de-problemas)
- [📚 Referencias](#-referencias)

---

## 🚀 Instalación Rápida

### Requisitos Previos
- **Python 3.10+** 
- **Jupyter Notebook/Lab**
- **GPU NVIDIA** (opcional, compatible con CPU)

### Instalación Automática (Recomendado)

```bash
# 1. Abrir terminal en Jupyter
# 2. Navegar al directorio
cd /workspace/ComfyUI

# 3. Ejecutar script de instalación
bash update_comfy.sh

# 4. Acceder vía proxy
# Abrir: /proxy/8188/
```

### Instalación Manual

```bash
# 1. Clonar/actualizar ComfyUI
cd /workspace/ComfyUI
git clone https://github.com/comfyanonymous/ComfyUI.git . || git pull

# 2. Crear entorno virtual
python3 -m venv .venv
source .venv/bin/activate

# 3. Instalar dependencias
python -m pip install --upgrade pip
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121
pip install -r requirements.txt

# 4. Lanzar ComfyUI
nohup python main.py --listen --port 8188 > comfy.log 2>&1 &
```

---

## 📁 Estructura del Proyecto

```
ComfyUI/
├── README.md                    # Esta guía
├── update_comfy.sh             # Script de actualización automática
├── main.py                     # Servidor principal de ComfyUI
├── requirements.txt            # Dependencias de Python
├── custom_nodes/               # Nodos personalizados
│   ├── inputFidelity/          # OpenAI Image Fidelity
│   ├── mirrorNode/             # YourMirror.io try-on
│   └── openai_simple_chat/     # Chat con OpenAI
└── models/                     # Modelos de IA (se crea automáticamente)
```

---

## ⚙️ Configuración

### Variables de Entorno

```bash
# Configurar API keys (opcional)
export OPENAI_API_KEY="tu_clave_openai"
export YOURMIRROR_API_KEY="tu_clave_yourmirror"

# Configurar directorio (por defecto)
export COMFY_DIR="/workspace/ComfyUI"
export PORT="8188"
```

### Rutas por Plataforma

| Plataforma | Ruta Típica | Comando de Navegación |
|------------|-------------|----------------------|
| **Vast.ai** | `/workspace/ComfyUI` | `cd /workspace/ComfyUI` |
| **Windows** | `C:\Users\TU_USUARIO\ComfyUI` | `cd C:\Users\TU_USUARIO\ComfyUI` |
| **Linux** | `/home/usuario/ComfyUI` | `cd /home/usuario/ComfyUI` |

---

## 🎯 Casos de Uso

### 1. **Generación de Imágenes Básica**
- Crear imágenes desde prompts de texto
- Usar modelos como SDXL, SD 1.5, etc.
- Control de parámetros (CFG, steps, sampler)

### 2. **Edición de Imágenes con Alta Fidelidad**
- Preservar detalles finos y texturas
- Cambios de color y estilo
- Extracción de productos para e-commerce

### 3. **Try-On Virtual de Ropa**
- Probar prendas virtualmente
- Múltiples tipos de accesorios
- Calidad normal y alta

### 4. **Análisis y Chat con Imágenes**
- Procesamiento de texto + imágenes
- Respuestas mejoradas en inglés
- Conversación persistente

---

## 🔧 Nodos Personalizados

### 🤖 **OpenAI Image Fidelity**
**Propósito**: Edición de imágenes con alta fidelidad para moda y productos

**Características**:
- ✅ Preserva detalles finos y texturas
- ✅ Presets especializados para moda
- ✅ Soporte multi-imagen y máscaras
- ✅ Fondos transparentes

**Instalación**:
```bash
cd custom_nodes/inputFidelity
pip install -r requirements.txt
```

### 👕 **YourMirror Virtual Try-On**
**Propósito**: Try-on virtual de ropa y accesorios

**Características**:
- ✅ Múltiples tipos de prendas
- ✅ Calidad configurable
- ✅ Soporte de máscaras
- ✅ Manejo robusto de errores

**Instalación**:
```bash
cd custom_nodes/mirrorNode
pip install -r requirements.txt
```

### 💬 **OpenAI Simple Chat**
**Propósito**: Chat inteligente con análisis de imágenes

**Características**:
- ✅ Procesamiento de texto + imágenes
- ✅ Detección automática de idioma
- ✅ Respuestas en inglés mejoradas
- ✅ Conversación persistente

**Instalación**:
```bash
cd custom_nodes/openai_simple_chat
pip install -r requirements.txt
```

---

## 🔄 Actualización

### Actualización Automática (Recomendado)

```bash
# Actualizar todo automáticamente
bash update_comfy.sh

# Con opciones personalizadas
COMFY_DIR="/workspace/ComfyUI" PORT="8188" UPGRADE_TORCH=1 bash update_comfy.sh
```

### Actualización Manual

```bash
# Actualizar ComfyUI
git pull
pip install -r requirements.txt

# Actualizar custom nodes
cd custom_nodes
for d in */; do
    [ -d "$d/.git" ] && (cd "$d" && git pull && pip install -r requirements.txt 2>/dev/null || true)
done
```

---

## 🌐 Acceso Web

### Métodos de Acceso

| Método | URL | Cuándo Usar |
|--------|-----|-------------|
| **Proxy Jupyter** | `/proxy/8188/` | ✅ **Recomendado** - Vast.ai, Jupyter |
| **Puerto Directo** | `http://IP:8188` | Solo si el puerto está expuesto |
| **Localhost** | `http://localhost:8188` | Instalación local |

### Verificar Estado del Servidor

```bash
# Ver logs en tiempo real
tail -f comfy.log

# Verificar proceso
ps aux | grep "python main.py"

# Verificar puerto
netstat -tlnp | grep 8188
```

---

## 🛠️ Solución de Problemas

### Problemas Comunes

#### ❌ **Error: "No module named 'torch'"**
```bash
# Reinstalar PyTorch
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121
```

#### ❌ **Error: "Port 8188 already in use"**
```bash
# Detener procesos existentes
pkill -f "python main.py"

# O usar puerto diferente
python main.py --listen --port 8189
```

#### ❌ **Error: "CUDA out of memory"**
```bash
# Usar versión CPU
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu

# O reducir batch size en la UI
```

#### ❌ **No se abre en el navegador**
```bash
# Verificar que se lanzó con --listen
ps aux | grep "python main.py"

# Usar proxy correcto: /proxy/8188/
# No: http://IP:8188
```

#### ❌ **Error de permisos en PowerShell**
```powershell
# Cambiar política de ejecución
Set-ExecutionPolicy -Scope Process RemoteSigned
```

### Comandos de Diagnóstico

```bash
# Verificar Python y dependencias
python --version
pip list | grep torch

# Verificar GPU
nvidia-smi

# Verificar puertos
netstat -tlnp | grep 8188

# Ver logs de errores
tail -n 50 comfy.log
```

---

## 📚 Referencias

### Enlaces Útiles
- [ComfyUI GitHub](https://github.com/comfyanonymous/ComfyUI)
- [ComfyUI Wiki](https://github.com/comfyanonymous/ComfyUI/wiki)
- [OpenAI API](https://platform.openai.com/docs)
- [YourMirror.io](https://yourmirror.io)

### Comandos Rápidos (Resumen)

```bash
# Instalación completa
cd /workspace/ComfyUI && bash update_comfy.sh

# Lanzar manualmente
cd /workspace/ComfyUI && source .venv/bin/activate && nohup python main.py --listen --port 8188 > comfy.log 2>&1 &

# Detener servicio
pkill -f "python main.py"

# Ver logs
tail -f comfy.log

# Acceso web
# Abrir: /proxy/8188/
```

---

## 🤝 Soporte

### Antes de Pedir Ayuda
1. ✅ Revisa esta documentación
2. ✅ Verifica los logs: `tail -f comfy.log`
3. ✅ Confirma que usas `/proxy/8188/`
4. ✅ Revisa que las API keys estén configuradas

### Información para Reportes
- **Plataforma**: Vast.ai / Windows / Linux
- **Python**: `python --version`
- **GPU**: `nvidia-smi` (si aplica)
- **Logs**: Últimas 50 líneas de `comfy.log`
- **Error específico**: Mensaje exacto del error

---

*Última actualización: Diciembre 2024*
