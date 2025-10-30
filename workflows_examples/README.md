# Workflows de ejemplo

Ejemplos listos para usar con los nodos de `customNodesChelogarcho`.

## Archivos

- `CL_ImageFidelity_example.json`: edición/análisis de imagen (OpenAI)
- `CL_GeminiFlash_example.json`: generación/edición (Gemini 2.5 Flash)
- `CL_OpenAIChat_example.json`: análisis con visión (OpenAI)
- `CL_VirtualTryOn_example.json`: try-on virtual (YourMirror.io)
- `combined_workflow_example.json`: pipeline combinado

## Uso

1) Arrastra el `.json` a ComfyUI.  
2) Ingresa las `api_key` en los nodos correspondientes.  
3) Conecta `LoadImage`/`SaveImage`/`Preview` si hace falta.  
4) Ejecuta con “Queue Prompt”.

Requisitos mínimos: ComfyUI v0.4+ y las `api_key` de cada servicio.

## Consejos

- Si ves conexiones rojas, revisa tipos de datos y conexiones requeridas.  
- Evita compartir workflows con claves embebidas.  
- Puedes duplicar y adaptar cualquiera de estos ejemplos.

—

Desarrollado por chelogarcho.
