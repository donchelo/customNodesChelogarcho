# Workflows de Ejemplo para Nodos Personalizados de Chelogarcho

Este directorio contiene workflows de ejemplo optimizados para ComfyUI que demuestran el uso de los nodos personalizados desarrollados por chelogarcho.

## 🚀 Workflows Disponibles

### 1. **CL_ImageFidelity_example.json**
**Descripción**: Workflow para edición de imágenes de moda con alta fidelidad usando OpenAI Image 1.

**Características**:
- ✅ **Entradas**: Imagen principal + imagen de referencia opcional
- ✅ **Procesamiento**: OpenAI Image Fidelity con presets de moda
- ✅ **Salidas**: Imagen editada + preview + información de debug
- ✅ **Organización**: Grupos visuales para Input, AI Processing y Output

**Uso**: Ideal para cambios de color de ropa, variaciones de estilo y edición de productos de moda.

---

### 2. **CL_GeminiFlash_example.json**
**Descripción**: Workflow para generación y edición de imágenes usando Google Gemini 2.5 Flash.

**Características**:
- ✅ **Entradas**: Imágenes opcionales para referencia y edición
- ✅ **Procesamiento**: Gemini Flash con múltiples modos (generación, edición, fusión)
- ✅ **Salidas**: Imagen generada + preview + información de debug
- ✅ **Organización**: Grupos visuales para Input, AI Generation y Output

**Uso**: Perfecto para generación de paisajes, edición de imágenes y composiciones creativas.

---

### 3. **CL_OpenAIChat_example.json**
**Descripción**: Workflow para análisis de imágenes usando ChatGPT con capacidades de visión.

**Características**:
- ✅ **Entradas**: Hasta 3 imágenes para análisis
- ✅ **Procesamiento**: OpenAI GPT con análisis visual y prompts personalizados
- ✅ **Salidas**: Análisis de texto + múltiples previews + guardado de respuestas
- ✅ **Organización**: Grupos visuales para Input, AI Chat Processing y Text Output

**Uso**: Excelente para análisis de moda, descripción de productos y asistencia visual.

---

### 4. **CL_VirtualTryOn_example.json**
**Descripción**: Workflow para probar virtualmente prendas usando YourMirror.io API.

**Características**:
- ✅ **Entradas**: Imagen de persona + imagen de producto + máscara opcional
- ✅ **Procesamiento**: Virtual Try-On con múltiples tipos de prendas
- ✅ **Salidas**: Imagen de resultado + preview + logs de debug
- ✅ **Organización**: Grupos visuales para Input, Virtual Try-On Processing y Output

**Uso**: Ideal para probar gafas, ropa, calzado y accesorios virtualmente.

---

### 5. **combined_workflow_example.json**
**Descripción**: Workflow completo que combina todos los nodos en un flujo de trabajo de moda.

**Características**:
- ✅ **Entradas**: Múltiples imágenes para diferentes propósitos
- ✅ **Procesamiento**: Análisis → Mejora → Try-On → Composición final
- ✅ **Salidas**: Múltiples resultados intermedios y finales
- ✅ **Organización**: 6 grupos visuales para flujo lógico y claro

**Uso**: Workflow completo para proyectos de moda profesionales.

---

## 🔧 Mejoras Implementadas

### **Según Mejores Prácticas de ComfyUI**

1. **✅ Conexiones Correctas**: Todos los inputs y outputs están correctamente conectados
2. **✅ Nodos de Entrada**: LoadImage para todas las imágenes de entrada
3. **✅ Nodos de Salida**: SaveImage, SaveText, PreviewImage, PreviewText apropiados
4. **✅ Flujo Lógico**: Orden de ejecución optimizado (order field)
5. **✅ Organización Visual**: Grupos de colores para mejor legibilidad
6. **✅ Posicionamiento**: Layout optimizado para flujo visual claro
7. **✅ Versión**: Compatible con ComfyUI v0.4+

### **Estructura Estándar de Cada Workflow**

```
Input Images → AI Processing → Output & Preview
     ↓              ↓              ↓
  LoadImage    Custom Node    SaveImage/Text
  LoadImage                  PreviewImage/Text
  LoadImage                  SaveDebug/Info
```

---

## 📋 Requisitos Previos

### **Nodos Personalizados Requeridos**
- `CL_ImageFidelity` - Para edición de imágenes de moda
- `CL_GeminiFlash` - Para generación con Gemini
- `CL_OpenAIChat` - Para análisis con ChatGPT
- `CL_VirtualTryOn` - Para try-on virtual

### **Dependencias de ComfyUI**
- Nodos estándar: `LoadImage`, `SaveImage`, `SaveText`, `PreviewImage`, `PreviewText`
- Versión mínima: ComfyUI v0.4+

### **API Keys Requeridas**
- **OpenAI**: Para Image Fidelity y Chat
- **Google**: Para Gemini Flash
- **YourMirror**: Para Virtual Try-On

---

## 🚀 Cómo Usar

1. **Importar Workflow**: Arrastra el archivo .json a ComfyUI
2. **Configurar API Keys**: Ingresa tus claves en los nodos correspondientes
3. **Cargar Imágenes**: Usa LoadImage para tus archivos
4. **Ejecutar**: Haz clic en "Queue Prompt" para procesar
5. **Revisar Resultados**: Usa los nodos de preview y save

---

## 🔍 Troubleshooting

### **Problemas Comunes**
- **Conexiones Rojas**: Verifica que los tipos de datos coincidan
- **Errores de API**: Confirma que las claves API sean válidas
- **Imágenes No Cargadas**: Asegúrate de que los archivos existan en la ruta especificada

### **Verificación de Workflow**
- Todos los nodos deben tener conexiones válidas
- Los inputs requeridos deben estar conectados
- Los outputs deben tener destinos apropiados

---

## 📚 Recursos Adicionales

- **Documentación ComfyUI**: [github.com/comfyanonymous/ComfyUI](https://github.com/comfyanonymous/ComfyUI)
- **Nodos Personalizados**: Ubicados en `custom_nodes/`
- **Ejemplos de Imágenes**: Usa cualquier imagen PNG/JPG para testing

---

## 🎯 Casos de Uso Recomendados

- **Moda y E-commerce**: Edición de productos, try-on virtual
- **Marketing**: Generación de contenido visual, análisis de imágenes
- **Diseño**: Composición de imágenes, variaciones de estilo
- **Investigación**: Análisis de tendencias, estudio de productos

---

*Desarrollado por chelogarcho - Optimizado para ComfyUI v0.4+*
