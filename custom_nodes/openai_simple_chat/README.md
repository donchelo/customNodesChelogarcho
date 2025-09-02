# OpenAI Simple Chat - Custom Node para ComfyUI

**Desarrollado por: chelogarcho** 🚀

Este custom node permite integrar chat con OpenAI usando la **Responses API** directamente en ComfyUI, facilitando el procesamiento de texto + imágenes y devolviendo respuestas mejoradas siempre en inglés.

## 🎯 Características Principales

- **🖼️ Soporte para Imágenes**: Procesa hasta 3 imágenes con OpenAI Vision
- **🌍 Detección Automática de Idioma**: Detecta el idioma del prompt del usuario
- **🇺🇸 Output Siempre en Inglés**: Respuestas mejoradas y profesionales en inglés
- **📏 Límite de Caracteres Configurable**: Control preciso sobre la longitud de respuesta
- **🔄 Conversación Persistente**: Mantiene historial de conversación
- **⚡ OpenAI Responses API**: Usa la API más reciente y eficiente

## 🚀 Instalación

### 1. Instalar dependencias

```bash
cd ComfyUI/custom_nodes/openai_simple_chat
pip install -r requirements.txt
```

### 2. Configurar API Key

**Opción A: Variables de entorno (Recomendado)**
```bash
export OPENAI_API_KEY="tu_clave_api_aqui"
```

**Opción B: Archivo .env**
```bash
cp config.env .env
# Editar .env y agregar tu clave API
```

**Opción C: Directamente en el nodo**
- Desactivar "use_env_key" en el nodo
- Ingresar la clave API en el campo correspondiente

### 3. Reiniciar ComfyUI

Reinicia ComfyUI para que los nuevos nodos sean detectados.

## 📋 Uso

### OpenAI Simple Chat

Este nodo procesa texto + imágenes y devuelve respuestas mejoradas en inglés:

**Parámetros de entrada (en orden exacto):**
1. `user_prompt`: Prompt del usuario (cualquier idioma, textarea multilinea)
2. `model`: Modelo a usar (dropdown: gpt-4o-mini, gpt-4o, gpt-4-turbo, gpt-4)
3. `max_characters`: Máximo número de caracteres (50-2000, default: 500)
4. `system_prompt`: Prompt del sistema (textarea multilinea)
5. `api_key`: Clave API de OpenAI (opcional si usas variables de entorno)
6. `image_1`: Primera imagen (opcional)
7. `image_2`: Segunda imagen (opcional)
8. `image_3`: Tercera imagen (opcional)
9. `use_env_key`: Si usar la clave API desde variables de entorno

**Salidas:**
- `response_text`: Respuesta mejorada en inglés

### OpenAI Conversation Chat

Este nodo mantiene el historial de la conversación con soporte para imágenes:

**Parámetros adicionales:**
- `clear_history`: Limpiar el historial de conversación

**Salidas:**
- `response_text`: Respuesta mejorada en inglés
- `conversation_summary`: Resumen de la conversación completa

## 🔄 Flujo de Trabajo

```
Input: "Cambia el vestido a azul" + imagen + system prompt
       ↓
Detecta: Español
       ↓
OpenAI: Procesa con vision + system prompt
       ↓
Output: "Transform the elegant dress to sophisticated navy blue while preserving..."
```

## 🎯 Casos de Uso

### 1. Fashion Enhancement
```
Input: "Cambia vestido a azul" + imagen
Output: "Transform the elegant dress to sophisticated navy blue with professional styling..."
```

### 2. Image Analysis
```
Input: "¿Qué hay aquí?" + imagen
Output: "The image shows a professional model wearing a contemporary fashion ensemble..."
```

### 3. Prompt Enhancement
```
Input: "Make it prettier" + imagen
Output: "Enhance with elegant styling, professional lighting, and refined composition..."
```

## ⚙️ Configuración Avanzada

### Modelos Disponibles
- `gpt-4o-mini`: Rápido y económico, ideal para pruebas
- `gpt-4o`: Balance entre velocidad y calidad
- `gpt-4-turbo`: Alta calidad para tareas complejas
- `gpt-4`: Máxima calidad (más costoso)

### Gestión de Caracteres
- Monitorea el uso de caracteres en los logs
- Ajusta `max_characters` según tus necesidades
- El sistema respeta estrictamente el límite configurado

### Detección de Idioma
- Detecta automáticamente español, inglés, francés, alemán, etc.
- Funciona con textos cortos y largos
- Fallback a inglés si no se puede detectar

## 🧪 Ejemplos de Uso

### Ejemplo 1: Procesamiento Simple
```
1. Conectar OpenAI Simple Chat
2. Configurar modelo: gpt-4o-mini
3. Escribir prompt: "Mejora esta imagen"
4. Conectar imagen
5. Ejecutar workflow
```

### Ejemplo 2: Conversación con Imágenes
```
1. Conectar OpenAI Conversation Chat
2. Configurar system prompt: "You are a fashion expert"
3. Enviar primer mensaje: "¿Qué estilo es este?"
4. Conectar imagen
5. El nodo mantendrá el contexto para futuras preguntas
```

### Ejemplo 3: Análisis Detallado
```
1. Configurar max_characters: 1000
2. System prompt: "You are a professional image analyst"
3. Prompt: "Describe every detail you see"
4. Conectar múltiples imágenes
5. Obtener análisis completo en inglés
```

## ⚠️ Solución de Problemas

### Error: "Clave API inválida"
- Verifica que tu clave API sea correcta
- Asegúrate de que tenga saldo disponible
- Revisa que la variable de entorno esté configurada correctamente

### Error: "Límite de tasa excedido"
- Espera unos minutos antes de hacer otra petición
- Considera usar gpt-4o-mini para reducir costos
- Verifica tu plan de OpenAI

### Error: "OPENAI_API_KEY no encontrada"
- Configura la variable de entorno: `export OPENAI_API_KEY="tu_clave"`
- O desactiva "use_env_key" e ingresa la clave directamente

### Las imágenes no se procesan
- Verifica que las imágenes estén en formato compatible
- Asegúrate de que el modelo seleccionado soporte vision
- Revisa los logs para errores específicos

### Los nodos no aparecen
- Verifica que las dependencias estén instaladas
- Reinicia ComfyUI completamente
- Revisa la consola de ComfyUI para errores

## 🔧 Dependencias

- `openai>=1.0.0`: Cliente oficial de OpenAI
- `Pillow>=9.0.0`: Procesamiento de imágenes
- `torch>=1.9.0`: Manejo de tensores de ComfyUI
- `numpy>=1.21.0`: Operaciones numéricas
- `langdetect>=1.0.9`: Detección de idioma
- `requests>=2.25.0`: Peticiones HTTP
- `typing-extensions>=4.0.0`: Tipos de Python

## 📝 Notas Técnicas

### Formato de Imágenes
- Soporta tensores de ComfyUI (torch.Tensor)
- Convierte automáticamente a base64 para OpenAI API
- Maneja formatos RGB, RGBA y grayscale
- Normaliza valores de 0-1 a 0-255

### Detección de Idioma
- Usa la librería `langdetect`
- Detecta más de 50 idiomas
- Fallback a inglés para textos muy cortos
- Logs informativos del idioma detectado

### Límites de Caracteres
- Respetado estrictamente en la respuesta
- Truncamiento inteligente en palabras completas
- Información de uso en logs

## 🤝 Contribuir

Si encuentras bugs o quieres agregar funcionalidades:

1. Fork el repositorio
2. Crea una rama para tu feature
3. Haz commit de tus cambios
4. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la licencia MIT. Ver el archivo LICENSE para más detalles.

## 🔗 Enlaces Útiles

- [Documentación de OpenAI API](https://platform.openai.com/docs)
- [ComfyUI Custom Nodes](https://github.com/comfyanonymous/ComfyUI)
- [Obtener API Key](https://platform.openai.com/api-keys)
- [OpenAI Vision Models](https://platform.openai.com/docs/guides/vision)
