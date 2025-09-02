# 🚀 ComfyUI Custom Nodes Index - by chelogarcho

**Desarrollado por: chelogarcho** 🚀

Este archivo sirve como índice principal para encontrar fácilmente todos los custom nodes desarrollados por **chelogarcho** en este repositorio.

## 🔍 Cómo Buscar los Custom Nodes

### **En ComfyUI:**
- Hacer clic derecho en el canvas
- Buscar por **"chelogarcho"** para encontrar todos los nodos
- O buscar por el nombre específico del nodo

### **En el Código:**
- Buscar por **"chelogarcho"** en cualquier archivo
- Buscar por **"Developer: chelogarcho"** en las clases principales

## 📋 Lista Completa de Custom Nodes

### 1. 🎯 **inputFidelity** - OpenAI Image Analysis
- **Nombre de Clase**: `OpenAIImageFidelityFashion`
- **Nombre de Visualización**: `OpenAI Image Fidelity Fashion (by chelogarcho)`
- **Categoría**: Image Processing
- **Funcionalidad**: Análisis de fidelidad de imágenes con OpenAI
- **Casos de Uso**: Moda, fotografía de productos, análisis de calidad
- **Archivo Principal**: `custom_nodes/inputFidelity/openai_image_fidelity_fashion.py`

### 2. 🔄 **MirrorNode** - Virtual Try-On
- **Nombre de Clase**: `YourMirrorVirtualTryOn`
- **Nombre de Visualización**: `YourMirror Virtual Try-On (by chelogarcho)`
- **Categoría**: Virtual Try-On
- **Funcionalidad**: Integración con YourMirror.io para probadores virtuales
- **Casos de Uso**: Ropa, calzado, accesorios
- **Archivo Principal**: `custom_nodes/mirrorNode/mirror_node.py`

### 3. 🍌 **bananaNode** - Gemini Flash Image
- **Nombre de Clase**: `GeminiFlashImage`
- **Nombre de Visualización**: `Gemini Flash Image (by chelogarcho)`
- **Categoría**: AI Image Generation
- **Funcionalidad**: Generación y edición de imágenes con Google Gemini 2.5 Flash
- **Casos de Uso**: Generación creativa, edición de imágenes, consistencia de personajes
- **Archivo Principal**: `custom_nodes/bananaNode/gemini_flash_image.py`

### 4. 💬 **openai_simple_chat** - AI Chat Integration
- **Nombre de Clase**: `OpenAI_Simple_Chat`
- **Nombre de Visualización**: `OpenAI Simple Chat (by chelogarcho)`
- **Categoría**: AI Chat
- **Funcionalidad**: Chat inteligente con OpenAI integrado en ComfyUI
- **Casos de Uso**: Análisis de imágenes, generación de prompts, asistencia
- **Archivo Principal**: `custom_nodes/openai_simple_chat/openai_simple_chat.py`

## 🔧 Instalación y Configuración

### **Instalación Automática:**
```bash
# Linux/macOS
chmod +x install_all_nodes.sh
./install_all_nodes.sh

# Windows
install_all_nodes.bat
```

### **Configuración:**
```bash
cp config.env.example config.env
# Editar config.env con tus API keys
```

## 📚 Documentación

- **README.md** - Visión general del proyecto
- **README_CUSTOM_NODES.md** - Documentación técnica detallada
- **workflows_examples/** - Ejemplos de workflows para cada nodo
- **custom_nodes/*/README.md** - Documentación específica de cada nodo

## 🎯 Casos de Uso Recomendados

### **Moda y E-commerce:**
- `inputFidelity` + `MirrorNode` = Análisis de productos + Try-on virtual

### **Generación Creativa:**
- `bananaNode` + `openai_simple_chat` = Generación de imágenes + Análisis con IA

### **Workflow Completo:**
- `combined_workflow_example.json` = Pipeline completo de análisis a resultado final

## 🔍 Búsqueda y Filtrado

### **Por Categoría:**
- **Image Processing**: inputFidelity
- **Virtual Try-On**: MirrorNode
- **AI Image Generation**: bananaNode
- **AI Chat**: openai_simple_chat

### **Por Tecnología:**
- **OpenAI**: inputFidelity, openai_simple_chat
- **Google**: bananaNode
- **YourMirror.io**: MirrorNode

### **Por Funcionalidad:**
- **Análisis de Imágenes**: inputFidelity, openai_simple_chat
- **Generación de Imágenes**: bananaNode
- **Try-On Virtual**: MirrorNode
- **Chat con IA**: openai_simple_chat

## 📞 Soporte

Para soporte técnico o preguntas específicas sobre los custom nodes:
- Revisa la documentación de cada nodo
- Consulta `README_CUSTOM_NODES.md`
- Contacta al desarrollador: **chelogarcho**

---

**¡Disfruta usando estos custom nodes para potenciar tu creatividad en ComfyUI! 🎨✨**

**Desarrollado con ❤️ por chelogarcho**
