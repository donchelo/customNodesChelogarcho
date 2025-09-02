# 🚀 ComfyUI Custom Nodes Collection

**Desarrollado por: chelogarcho**

Una colección completa de nodos personalizados para ComfyUI que extienden las capacidades de generación y procesamiento de imágenes con IA.

## 📋 Nodos Incluidos

### 1. 🎯 **inputFidelity** - OpenAI Image Analysis
- **Funcionalidad**: Análisis de fidelidad de imágenes con OpenAI
- **Casos de uso**: Moda, fotografía de productos, análisis de calidad
- **Características**: 
  - Control de fidelidad alta/baja
  - Presets especializados para moda
  - Soporte para máscaras y imágenes de referencia
  - Múltiples formatos de salida

### 2. 🔄 **MirrorNode** - Virtual Try-On
- **Funcionalidad**: Integración con YourMirror.io para probadores virtuales
- **Casos de uso**: Ropa, calzado, accesorios
- **Características**:
  - Soporte para múltiples tipos de productos
  - Calidad normal y alta
  - Sistema de reintentos automático
  - Logs detallados para debugging

### 3. 🍌 **bananaNode** - Gemini Flash Image
- **Funcionalidad**: Generación y edición de imágenes con Google Gemini 2.5 Flash
- **Casos de uso**: Generación creativa, edición de imágenes, consistencia de personajes
- **Características**:
  - Múltiples modos de operación
  - Fusión multi-imagen
  - Consistencia de personajes
  - Conocimiento del mundo real

### 4. 💬 **openai_simple_chat** - AI Chat Integration
- **Funcionalidad**: Chat inteligente con OpenAI integrado en ComfyUI
- **Casos de uso**: Análisis de imágenes, generación de prompts, asistencia
- **Características**:
  - Soporte para múltiples modelos GPT
  - Procesamiento de imágenes con visión
  - Respuestas en inglés mejoradas
  - Control de longitud de respuesta

## 🚀 Instalación Rápida

### Opción 1: Instalación Automática (Recomendada)
```bash
# Desde la raíz de ComfyUI
chmod +x install_all_nodes.sh
./install_all_nodes.sh
```

### Opción 2: Instalación Manual
```bash
# Instalar dependencias unificadas
pip install -r requirements_all_nodes.txt

# O instalar cada nodo individualmente
cd custom_nodes/inputFidelity && pip install -r requirements.txt
cd ../mirrorNode && pip install -r requirements.txt
cd ../bananaNode && pip install -r requirements.txt
cd ../openai_simple_chat && pip install -r requirements.txt
```

## ⚙️ Configuración

### API Keys Requeridas

#### OpenAI (inputFidelity + openai_simple_chat)
```bash
# Crear archivo config.env en el directorio del nodo
OPENAI_API_KEY=tu_api_key_aqui
```

#### Google (bananaNode)
```bash
# Crear archivo config.env en el directorio del nodo
GOOGLE_API_KEY=tu_api_key_aqui
```

#### YourMirror.io (MirrorNode)
```json
# Crear archivo config.json en el directorio del nodo
{
    "api_key": "tu_api_key_aqui",
    "api_base_url": "https://apiservice.yourmirror.io"
}
```

## 📁 Estructura del Proyecto

```
ComfyUI/
├── custom_nodes/
│   ├── inputFidelity/          # OpenAI Image Analysis
│   ├── mirrorNode/             # Virtual Try-On
│   ├── bananaNode/             # Gemini Flash Image
│   └── openai_simple_chat/     # AI Chat Integration
├── install_all_nodes.sh        # Script de instalación automática
├── requirements_all_nodes.txt   # Dependencias unificadas
└── README_CUSTOM_NODES.md      # Esta documentación
```

## 🔧 Uso

### 1. Reiniciar ComfyUI
Después de la instalación, reinicia ComfyUI para que los nuevos nodos estén disponibles.

### 2. Localizar los Nodos
Los nodos aparecerán en las siguientes categorías:
- **inputFidelity**: Categoría personalizada
- **MirrorNode**: Categoría "YourMirror"
- **bananaNode**: Categoría personalizada
- **openai_simple_chat**: Categoría "AI/Chat"

### 3. Configurar API Keys
Asegúrate de tener configuradas las API keys necesarias antes de usar los nodos.

## 📚 Ejemplos y Workflows

Cada nodo incluye:
- `README.md` con documentación específica
- `example_workflow.json` con ejemplos de uso
- `requirements.txt` con dependencias específicas

## 🐛 Solución de Problemas

### Error: "Module not found"
```bash
# Verificar que las dependencias estén instaladas
pip list | grep nombre_del_modulo

# Reinstalar dependencias
pip install -r requirements_all_nodes.txt
```

### Error: "API key not found"
- Verifica que los archivos de configuración estén en el lugar correcto
- Asegúrate de que las variables de entorno estén configuradas
- Revisa la documentación específica de cada nodo

### Error: "Permission denied" en script de instalación
```bash
chmod +x install_all_nodes.sh
```

## 🤝 Contribuciones

Este proyecto es desarrollado por **chelogarcho**. Para contribuciones o reportes de bugs, por favor contacta al desarrollador.

## 📄 Licencia

Todos los nodos están desarrollados por chelogarcho. Verifica la licencia específica de cada nodo en su directorio correspondiente.

## 🔗 Enlaces Útiles

- [ComfyUI Official](https://github.com/comfyanonymous/ComfyUI)
- [OpenAI API](https://platform.openai.com/)
- [Google AI Studio](https://aistudio.google.com/)
- [YourMirror.io](https://yourmirror.io/)

---

**¡Disfruta usando estos custom nodes para potenciar tu creatividad en ComfyUI! 🎨✨**
