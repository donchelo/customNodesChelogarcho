# 🚀 ComfyUI Custom Nodes Collection

**Desarrollado por: chelogarcho** 🎨

Una colección completa de nodos personalizados para ComfyUI que extienden las capacidades de generación y procesamiento de imágenes con IA, optimizada para entornos Vast.ai y uso local.

## 🌟 Características Principales

- **4 Custom Nodes Especializados** desarrollados por chelogarcho
- **Instalación Automática** con scripts para Windows y Linux/macOS
- **Configuración Simplificada** con archivos de ejemplo
- **Workflows de Ejemplo** listos para usar
- **Documentación Completa** para cada nodo
- **Optimizado para Vast.ai** con soporte para `/proxy/8188/`

## 📋 Custom Nodes Incluidos

### 🎯 **inputFidelity** - OpenAI Image Analysis
**Análisis de fidelidad de imágenes con OpenAI**
- Alta fidelidad de entrada para preservar detalles finos
- Presets especializados para moda y fotografía de productos
- Soporte para máscaras y múltiples imágenes de referencia
- Fondos transparentes para e-commerce

### 🔄 **MirrorNode** - Virtual Try-On
**Integración con YourMirror.io para probadores virtuales**
- Soporte para ropa, calzado y accesorios
- Calidad normal y alta con reintentos automáticos
- Sistema de logging detallado para debugging
- API robusta con manejo de errores

### 🍌 **bananaNode** - Gemini Flash Image
**Generación y edición con Google Gemini 2.5 Flash**
- Múltiples modos de operación (generación, edición, fusión)
- Consistencia de personajes y conocimiento del mundo real
- Fusión multi-imagen para resultados complejos
- Control granular sobre la generación

### 💬 **openai_simple_chat** - AI Chat Integration
**Chat inteligente con OpenAI integrado en ComfyUI**
- Soporte para múltiples modelos GPT
- Procesamiento de imágenes con visión
- Respuestas en inglés mejoradas
- Control de longitud de respuesta

## 🚀 Instalación Rápida

### **Opción 1: Instalación Automática (Recomendada)**

#### Linux/macOS:
```bash
chmod +x install_all_nodes.sh
./install_all_nodes.sh
```

#### Windows:
```cmd
install_all_nodes.bat
```

### **Opción 2: Instalación Manual**
```bash
pip install -r requirements_all_nodes.txt
```

## ⚙️ Configuración

### **1. Copiar archivo de configuración:**
```bash
cp config.env.example config.env
```

### **2. Configurar API keys en `config.env`:**
```bash
# OpenAI (para inputFidelity y openai_simple_chat)
OPENAI_API_KEY=tu_api_key_aqui

# Google (para bananaNode)
GOOGLE_API_KEY=tu_api_key_aqui

# YourMirror.io (para MirrorNode)
YOURMIRROR_API_KEY=tu_api_key_aqui
```

### **3. Reiniciar ComfyUI**

## 📁 Estructura del Proyecto

```
customNodesChelogarcho/
├── custom_nodes/                    # Custom nodes desarrollados por chelogarcho
│   ├── inputFidelity/              # OpenAI Image Analysis
│   │   ├── openai_image_fidelity_fashion.py
│   │   ├── requirements.txt
│   │   └── README.md
│   ├── mirrorNode/                 # Virtual Try-On
│   │   ├── mirror_node.py
│   │   ├── requirements.txt
│   │   └── README.md
│   ├── bananaNode/                 # Gemini Flash Image
│   │   ├── gemini_flash_image.py
│   │   ├── requirements.txt
│   │   └── README.md
│   └── openai_simple_chat/         # AI Chat Integration
│       ├── openai_simple_chat.py
│       ├── requirements.txt
│       └── README.md
├── workflows_examples/              # Ejemplos de workflows para cada nodo
│   ├── inputFidelity_example.json
│   ├── mirrorNode_example.json
│   ├── bananaNode_example.json
│   ├── openai_simple_chat_example.json
│   └── combined_workflow_example.json
├── install_all_nodes.sh            # Script de instalación para Linux/macOS
├── install_all_nodes.bat           # Script de instalación para Windows
├── install_custom_nodes.sh         # Script alternativo de instalación
├── requirements_all_nodes.txt      # Dependencias unificadas
├── config.env.example              # Configuración de ejemplo
├── CUSTOM_NODES_INDEX.md           # Índice completo de custom nodes
├── README_CUSTOM_NODES.md          # Documentación técnica detallada
└── test_nodes.py                   # Script de prueba para verificar instalación
```

## 🔧 Uso

### **1. Ejecutar ComfyUI:**
```bash
python main.py
```

### **2. Acceder a la interfaz web:**
- **Local**: http://localhost:8188
- **Vast.ai**: http://proxy/8188/

### **3. Encontrar los custom nodes:**
- Hacer clic derecho en el canvas
- Buscar por **"chelogarcho"** para encontrar todos los nodos
- O buscar por el nombre específico del nodo

## 📚 Documentación

- **[CUSTOM_NODES_INDEX.md](CUSTOM_NODES_INDEX.md)**: Índice completo y búsqueda de custom nodes
- **[README_CUSTOM_NODES.md](README_CUSTOM_NODES.md)**: Documentación técnica detallada
- **workflows_examples/**: Ejemplos de workflows para cada nodo
- **custom_nodes/*/README.md**: Documentación específica de cada nodo

## 🎯 Casos de Uso Recomendados

### **Moda y E-commerce:**
- `inputFidelity` + `MirrorNode` = Análisis de productos + Try-on virtual

### **Generación Creativa:**
- `bananaNode` + `openai_simple_chat` = Generación de imágenes + Análisis con IA

### **Workflow Completo:**
- `combined_workflow_example.json` = Pipeline completo de análisis a resultado final

## 🐛 Solución de Problemas

### **Error: "Module not found"**
```bash
pip install -r requirements_all_nodes.txt
```

### **Error: "API key not found"**
- Verificar archivo `config.env`
- Configurar variables de entorno
- Revisar documentación específica de cada nodo

### **Error: "Permission denied" en script**
```bash
chmod +x install_all_nodes.sh
```

### **Verificar instalación:**
```bash
python test_nodes.py
```

## 🔄 Actualización

Para actualizar a la última versión:

```bash
git pull origin main
./install_all_nodes.sh
```

## 🌐 Soporte para Vast.ai

Este proyecto está optimizado para entornos Vast.ai con Jupyter:

- **Acceso**: http://proxy/8188/
- **Instalación automática** con scripts incluidos
- **Configuración simplificada** para despliegues rápidos
- **Dependencias unificadas** para evitar conflictos

## 🤝 Contribuciones

Este proyecto es desarrollado por **chelogarcho**. Para contribuciones o reportes de bugs, por favor contacta al desarrollador.

## 📄 Licencia

ComfyUI tiene su propia licencia. Los custom nodes están desarrollados por chelogarcho.

## 🔗 Enlaces Útiles

- [ComfyUI Official](https://github.com/comfyanonymous/ComfyUI)
- [OpenAI API](https://platform.openai.com/)
- [Google AI Studio](https://aistudio.google.com/)
- [YourMirror.io](https://yourmirror.io/)

---

**¡Disfruta usando ComfyUI con estos custom nodes para potenciar tu creatividad! 🎨✨**

**Desarrollado con ❤️ por chelogarcho**
