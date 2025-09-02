# 📚 Workflows de Ejemplo - ComfyUI Custom Nodes

**Desarrollado por: chelogarcho**

Esta carpeta contiene ejemplos de workflows para cada custom node, mostrando cómo usarlos individualmente y en combinación.

## 🎯 Workflows Individuales

### 1. **CL_ImageFidelity_example.json**
- **Nodo**: CL_ImageFidelity (OpenAI Image Fidelity Fashion)
- **Funcionalidad**: Cambio de color de outfit preservando detalles
- **Uso**: Cargar imagen de moda → Aplicar cambios → Guardar resultado

### 2. **CL_VirtualTryOn_example.json**
- **Nodo**: CL_VirtualTryOn (YourMirror Virtual Try-On)
- **Funcionalidad**: Probar gafas virtualmente
- **Uso**: Cargar imagen de persona + producto → Aplicar try-on → Guardar resultado

### 3. **CL_GeminiFlash_example.json**
- **Nodo**: CL_GeminiFlash (Google Gemini Flash Image)
- **Funcionalidad**: Generación de paisajes con Gemini
- **Uso**: Escribir prompt → Generar imagen → Guardar resultado

### 4. **CL_OpenAIChat_example.json**
- **Nodo**: CL_OpenAIChat (OpenAI Simple Chat)
- **Funcionalidad**: Análisis de imagen de moda
- **Uso**: Cargar imagen → Analizar con IA → Guardar análisis

## 🔄 Workflow Combinado

### 5. **combined_workflow_example.json**
- **Nodos**: Todos los custom nodes trabajando juntos
- **Funcionalidad**: Pipeline completo de análisis y mejora de moda
- **Flujo**:
  1. **Análisis**: Chat con IA analiza imagen de moda
  2. **Mejora**: inputFidelity aplica sugerencias
  3. **Try-On**: MirrorNode prueba nueva prenda
  4. **Composición**: bananaNode crea resultado final

## 📖 Cómo Usar los Workflows

### 1. **Cargar en ComfyUI**
- Abrir ComfyUI
- Hacer clic en "Load" en la barra superior
- Seleccionar el archivo .json deseado

### 2. **Configurar API Keys**
- Asegúrate de tener configuradas las API keys necesarias
- Ver `config.env.example` para configuración

### 3. **Personalizar**
- Modifica los prompts según tus necesidades
- Ajusta parámetros como calidad, tamaño, etc.
- Cambia las imágenes de entrada

### 4. **Ejecutar**
- Hacer clic en "Queue Prompt" para ejecutar
- Monitorear el progreso en la consola
- Los resultados se guardarán automáticamente

## 🎨 Casos de Uso Recomendados

### **Moda y E-commerce**
- `CL_ImageFidelity_example.json` + `CL_VirtualTryOn_example.json`
- Análisis de productos + Try-on virtual

### **Generación Creativa**
- `CL_GeminiFlash_example.json` + `CL_OpenAIChat_example.json`
- Generación de imágenes + Análisis con IA

### **Workflow Completo**
- `combined_workflow_example.json`
- Pipeline completo de análisis a resultado final

## ⚠️ Notas Importantes

1. **API Keys**: Todos los workflows requieren API keys configuradas
2. **Imágenes**: Los workflows usan nombres de archivo de ejemplo
3. **Dependencias**: Asegúrate de que todos los custom nodes estén instalados
4. **Configuración**: Revisa la documentación de cada nodo para opciones avanzadas

## 🔧 Personalización

### **Modificar Prompts**
```json
"prompt": "Tu prompt personalizado aquí"
```

### **Cambiar Modelos**
```json
"model": "gpt-4o"  // Para openai_simple_chat
```

### **Ajustar Calidad**
```json
"quality": "high"  // Para inputFidelity y mirrorNode
```

## 📞 Soporte

Para preguntas sobre los workflows o personalización:
- Revisa la documentación de cada nodo
- Consulta `README_CUSTOM_NODES.md`
- Contacta al desarrollador: chelogarcho

---

**¡Disfruta explorando las posibilidades de estos custom nodes! 🚀✨**
