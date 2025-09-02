# 🚀 ComfyUI Custom Nodes Collection - by chelogarcho

**Desarrollado por: chelogarcho** 🎨

Una colección completa de nodos personalizados para ComfyUI que extienden las capacidades de generación y procesamiento de imágenes con IA, **optimizada para entornos Vast.ai y uso local**.

## 🌟 **Instalación Rápida para Jupyter/Vast.ai**

### **Opción 1: Una sola línea (Recomendada)**
```bash
curl -sSL https://raw.githubusercontent.com/chelogarcho/customNodesChelogarcho/main/install_jupyter.sh | bash
```

### **Opción 2: Descargar y ejecutar**
```bash
cd ComfyUI/custom_nodes/
git clone https://github.com/chelogarcho/customNodesChelogarcho.git
cd customNodesChelogarcho
chmod +x install_jupyter.sh
./install_jupyter.sh
```

### **Opción 3: Instalación Ultra-Simple**
```bash
./install_jupyter.sh --ultra-simple
```

### **Acceso desde Jupyter:**
- **URL**: `http://proxy/8188/`
- **Buscar nodos**: Busca por **"chelogarcho"** en ComfyUI

## 📋 **Custom Nodes Incluidos**

| Nodo | Función | Tecnología | Caso de Uso |
|------|---------|------------|--------------|
| **inputFidelity** | Análisis de fidelidad de imágenes | OpenAI | Moda, productos, e-commerce |
| **MirrorNode** | Virtual Try-On | YourMirror.io | Ropa, calzado, accesorios |
| **bananaNode** | Generación/edición de imágenes | Google Gemini 2.5 Flash | Generación creativa, consistencia |
| **openai_simple_chat** | Chat inteligente | OpenAI GPT | Análisis, prompts, asistencia |

## 🔑 **API Keys Visibles (NUEVO)**

**Todos los nodos tienen campos visibles para las API keys**, eliminando la necesidad de archivos de configuración:

- ✅ **inputFidelity**: Campo `api_key` para OpenAI
- ✅ **MirrorNode**: Campo `api_key` para YourMirror.io  
- ✅ **bananaNode**: Campo `api_key` para Google
- ✅ **openai_simple_chat**: Campo `api_key` para OpenAI

### **Cómo usar:**
1. **Arrastrar nodo** al canvas
2. **Hacer clic en campo `api_key`**
3. **Pegar tu API key**
4. **Ejecutar workflow**

## 🎯 **Casos de Uso Recomendados**

### **Moda y E-commerce:**
```bash
inputFidelity + MirrorNode = Análisis de productos + Try-on virtual
```

### **Generación Creativa:**
```bash
bananaNode + openai_simple_chat = Generación de imágenes + Análisis con IA
```

### **Workflow Completo:**
```bash
combined_workflow_example.json = Pipeline completo de análisis a resultado final
```

## ⚙️ **Configuración de API Keys**

### **Obtener API Keys:**
```bash
# OpenAI (inputFidelity + openai_simple_chat)
https://platform.openai.com/api-keys

# Google (bananaNode)
https://aistudio.google.com/app/apikey

# YourMirror.io (MirrorNode)
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
./install_jupyter.sh  # Reinstalar dependencias
# O para instalación rápida:
./install_jupyter.sh --ultra-simple
```

### **Verificar instalación:**
```bash
python test_nodes.py
```

## 📁 **Estructura del Proyecto**

```
customNodesChelogarcho/
├── install_jupyter.sh           # 🚀 INSTALADOR ÚNICO para Jupyter/Vast.ai
├── custom_nodes/                # Custom nodes desarrollados por chelogarcho
│   ├── inputFidelity/          # OpenAI Image Analysis
│   ├── mirrorNode/             # Virtual Try-On
│   ├── bananaNode/             # Gemini Flash Image
│   └── openai_simple_chat/     # AI Chat Integration
├── workflows_examples/          # Ejemplos de workflows para cada nodo
├── config.env.example           # Configuración de ejemplo (opcional)
├── requirements_all_nodes.txt   # Dependencias unificadas
└── test_nodes.py                # Testing
```

## 🌐 **Optimizado para Vast.ai**

- **Acceso**: `http://proxy/8188/`
- **Instalación automática** con un solo comando
- **API keys visibles** en cada nodo
- **No más configuración** complicada
- **Funciona inmediatamente** después de la instalación

## 🔄 **Actualización**

```bash
git pull origin main
./install_jupyter.sh
# O para actualización rápida:
./install_jupyter.sh --ultra-simple
```

## 🤝 **Soporte**

- **Desarrollador**: chelogarcho
- **Documentación**: Este README.md contiene toda la información
- **Ejemplos**: `workflows_examples/`

---

**¡Ahora es más fácil que nunca usar los custom nodes! 🚀**

**Desarrollado con ❤️ por chelogarcho**
