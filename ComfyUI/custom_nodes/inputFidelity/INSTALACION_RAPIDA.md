# 🚀 Instalación Rápida - OpenAI Image Fidelity Fashion

## 📋 Requisitos Previos
- ComfyUI instalado y funcionando
- Clave API de OpenAI válida
- Python 3.8+

## ⚡ Instalación en 3 Pasos

### 1. Configurar API Key
Edita el archivo `config.env` en esta carpeta:
```bash
# Abre config.env y reemplaza "tu_clave_api_aqui" con tu clave real
OPENAI_API_KEY=sk-tu_clave_real_aqui
```

### 2. Instalar Dependencias
```bash
pip install openai pillow torch numpy
```

### 3. Reiniciar ComfyUI
- Detén ComfyUI si está corriendo
- Reinicia ComfyUI
- El nodo aparecerá en la categoría "OpenAI/Fashion"

## 🔧 Solución de Problemas

### Error: "No image generation calls found in Responses API response"
**Causa:** Problema con la estructura de la respuesta de la API
**Solución:** 
1. Verifica que tu API key sea válida
2. Asegúrate de tener créditos en tu cuenta de OpenAI
3. Usa el método "Images API" en lugar de "Responses API"

### Error: "OPENAI_API_KEY no encontrada"
**Solución:**
1. Verifica que el archivo `config.env` existe
2. Asegúrate de que la clave API esté correctamente configurada
3. Reinicia ComfyUI después de cambiar la configuración

### Error: "Module not found"
**Solución:**
```bash
pip install openai pillow torch numpy
```

## 🎯 Uso Rápido

1. **Cargar imagen** en el nodo "OpenAI Image Fidelity (Fashion)"
2. **Escribir prompt** describiendo los cambios deseados
3. **Seleccionar preset** de moda (opcional)
4. **Ejecutar** el workflow

## 📞 Soporte
Si tienes problemas, revisa los logs de ComfyUI para mensajes de debug detallados.