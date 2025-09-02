# 🚀 ComfyUI Custom Nodes Collection - by chelogarcho

**Desarrollado por: chelogarcho** 🎨

Una colección completa de nodos personalizados para ComfyUI que extienden las capacidades de generación y procesamiento de imágenes con IA, **optimizada para entornos Vast.ai y uso local**.

> 🆕 **NUEVO: Estructura completa siguiendo Fill-Nodes**  
> Todos los nodos están organizados en estructura de paquete Python con `__init__.py` para máxima compatibilidad, siguiendo exactamente las mejores prácticas de ComfyUI_Fill-Nodes.

## 🌟 **Instalación Rápida para Jupyter/Vast.ai**

### **Opción 1: Una sola línea (Recomendada)**
```bash
curl -sSL https://raw.githubusercontent.com/donchelo/customNodesChelogarcho/main/install_jupyter.sh | bash
```

### **Opción 2: Descargar y ejecutar**
```bash
cd ComfyUI/custom_nodes/
git clone https://github.com/donchelo/customNodesChelogarcho.git
cd customNodesChelogarcho
chmod +x install_jupyter.sh
./install_jupyter.sh
```

### **Opción 2.1: Para Windows**
```cmd
cd ComfyUI\custom_nodes\
git clone https://github.com/donchelo/customNodesChelogarcho.git
cd customNodesChelogarcho
install_jupyter.bat
```

### **Opción 3: Instalación Ultra-Simple**
```bash
# Linux/Mac
./install_jupyter.sh --ultra-simple

# Windows
install_jupyter.bat --ultra-simple
```

### **🚀 Opción Principal: Estructura de Paquete (Recomendada)**
```bash
# Instalación estándar (como ComfyUI_Fill-Nodes)
./install_jupyter.sh

# Para Windows:
install_jupyter.bat
```

### **🌍 Instalador Universal (Desde cualquier ubicación)**
```bash
# Linux/Mac - Ejecutar desde cualquier lugar
./install_anywhere.sh

# Windows - Ejecutar desde cualquier lugar
install_anywhere.bat
```

### **Acceso desde Jupyter:**
- **URL**: `http://proxy/8188/`
- **Buscar nodos**: Busca por **"chelogarcho"** en ComfyUI

## 📋 **Custom Nodes Incluidos**

| Nodo | Función | Tecnología | Caso de Uso |
|------|---------|------------|--------------|
| **CL_ImageFidelity** | Análisis de fidelidad de imágenes | OpenAI | Moda, productos, e-commerce |
| **CL_VirtualTryOn** | Virtual Try-On | YourMirror.io | Ropa, calzado, accesorios |
| **CL_GeminiFlash** | Generación/edición de imágenes | Google Gemini 2.5 Flash | Generación creativa, consistencia |
| **CL_OpenAIChat** | Chat inteligente | OpenAI GPT | Análisis, prompts, asistencia |

### **📁 Formato Principal (Estructura de Paquete)**

**Todos los nodos están organizados en estructura de paquete Python siguiendo Fill-Nodes:**

```
customNodesChelogarcho/
├── __init__.py              ← Registra todos los nodos
├── nodes/                   ← Directorio de nodos
│   ├── CL_ImageFidelity.py
│   ├── CL_VirtualTryOn.py  
│   ├── CL_GeminiFlash.py
│   └── CL_OpenAIChat.py
└── requirements_all_nodes.txt
```

**Instalación estándar:**
```bash
./install_jupyter.sh
```

## 🏗️ **Estructura del Proyecto (NUEVO)**

**Siguiendo las mejores prácticas de ComfyUI_Fill-Nodes:**

```
ComfyUI/
├── custom_nodes/
│   └── customNodesChelogarcho/     ← Clonar aquí
│       ├── __init__.py             ← Registra todos los nodos
│       ├── nodes/                  ← Directorio de nodos
│       │   ├── CL_ImageFidelity.py
│       │   ├── CL_VirtualTryOn.py  
│       │   ├── CL_GeminiFlash.py
│       │   └── CL_OpenAIChat.py
│       └── requirements_all_nodes.txt
└── main.py
```

**Ventajas de esta estructura:**
- ✅ **Compatibilidad total** con ComfyUI
- ✅ **Fácil mantenimiento** y actualizaciones
- ✅ **Sigue estándares** de la comunidad
- ✅ **Auto-registro** de nodos al cargar

## 🔑 **API Keys Visibles (NUEVO)**

**Todos los nodos tienen campos visibles para las API keys**, eliminando la necesidad de archivos de configuración:

- ✅ **CL_ImageFidelity**: Campo `api_key` para OpenAI
- ✅ **CL_VirtualTryOn**: Campo `api_key` para YourMirror.io  
- ✅ **CL_GeminiFlash**: Campo `api_key` para Google
- ✅ **CL_OpenAIChat**: Campo `api_key` para OpenAI

### **Cómo usar:**
1. **Arrastrar nodo** al canvas
2. **Hacer clic en campo `api_key`**
3. **Pegar tu API key**
4. **Ejecutar workflow**

## 🎯 **Casos de Uso Recomendados**

### **Moda y E-commerce:**
```bash
CL_ImageFidelity + CL_VirtualTryOn = Análisis de productos + Try-on virtual
```

### **Generación Creativa:**
```bash
CL_GeminiFlash + CL_OpenAIChat = Generación de imágenes + Análisis con IA
```

### **Workflow Completo:**
```bash
combined_workflow_example.json = Pipeline completo de análisis a resultado final
```

## ⚙️ **Configuración de API Keys**

### **Obtener API Keys:**
```bash
# OpenAI (CL_ImageFidelity + CL_OpenAIChat)
https://platform.openai.com/api-keys

# Google (CL_GeminiFlash)
https://aistudio.google.com/app/apikey

# YourMirror.io (CL_VirtualTryOn)
https://yourmirror.io/
```

### **No más archivos config.env:**
- **Eliminar** archivos `config.env`
- **Usar** campos `api_key` en los nodos
- **Funciona inmediatamente** sin reiniciar ComfyUI

## 🔧 **Uso en ComfyUI**

### **1. Buscar nodos:**
- Clic derecho en canvas → Buscar **"chelogarcho"**
- O buscar por nombre específico del nodo

### **2. Configurar API keys:**
- **Pegar API key** en el campo `api_key` del nodo
- **No compartir** workflows con API keys incluidas

### **3. Ejemplos incluidos:**
- `workflows_examples/` - Workflows listos para usar
- `combined_workflow_example.json` - Pipeline completo

## 🐛 **Solución de Problemas**

### **Error: "API Key is required"**
- **Solución**: Asegúrate de que el campo `api_key` no esté vacío
- **Verificar**: El campo debe tener tu API key real

### **Error: "Module not found"**
```bash
# Reinstalar dependencias (archivos únicos):
./install_jupyter.sh --single-files

# Para Windows:
install_jupyter.bat --single-files
```

### **Verificar instalación:**
```bash
python test_nodes.py
```

## 📁 **Estructura del Proyecto**

```
customNodesChelogarcho/
├── install_jupyter.sh           # 🚀 INSTALADOR ÚNICO para Jupyter/Vast.ai
├── install_anywhere.sh          # 🌍 INSTALADOR UNIVERSAL (Linux/Mac)
├── install_anywhere.bat         # 🌍 INSTALADOR UNIVERSAL (Windows)
├── nodes/                       # 🆕 ARCHIVOS ÚNICOS (como ComfyUI_Fill-Nodes)
│   ├── CL_ImageFidelity.py     # OpenAI Image Analysis (archivo único)
│   ├── CL_VirtualTryOn.py      # Virtual Try-On (archivo único)
│   ├── CL_GeminiFlash.py       # Gemini Flash Image (archivo único)
│   └── CL_OpenAIChat.py        # AI Chat Integration (archivo único)
├── workflows_examples/          # Ejemplos de workflows para cada nodo
├── config.env.example           # Configuración de ejemplo (opcional)
├── requirements_all_nodes.txt   # Dependencias unificadas
├── test_nodes.py                # Testing
├── cleanup_old_structure.bat    # Limpieza para Windows
├── cleanup_old_structure.sh     # Limpieza para Linux/Mac
└── INSTALADORES_UNIVERSALES.md  # Documentación de instaladores universales

## 🌐 **Optimizado para Vast.ai**

- **Acceso**: `http://proxy/8188/`
- **Instalación automática** con un solo comando
- **API keys visibles** en cada nodo
- **No más configuración** complicada
- **Funciona inmediatamente** después de la instalación

## 🔄 **Actualización**

```bash
git pull origin main

# Actualizar archivos únicos (recomendado):
./install_jupyter.sh --single-files

# Para Windows:
install_jupyter.bat --single-files

# Instalador universal (desde cualquier ubicación):
./install_anywhere.sh          # Linux/Mac
install_anywhere.bat           # Windows

# Nota: La estructura antigua ya no está disponible
# Todos los nodos están consolidados en archivos únicos
```

## 🤝 **Soporte**

- **Desarrollador**: chelogarcho
- **Documentación**: Este README.md contiene toda la información
- **Ejemplos**: `workflows_examples/`

---

**¡Ahora es más fácil que nunca usar los custom nodes! 🚀**

**Desarrollado con ❤️ por chelogarcho**
