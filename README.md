# ComfyUI Custom Nodes por chelogarcho

Colección de nodos personalizados para ComfyUI. Diseño simple, sin configuraciones externas, con campos `api_key` visibles en cada nodo. Optimizado para uso local y entornos Jupyter/Vast.ai.

## Instalación (recomendada)

```bash
cd ComfyUI/custom_nodes/
git clone https://github.com/donchelo/customNodesChelogarcho.git
cd customNodesChelogarcho
pip install -r requirements_all_nodes.txt
```

- Reinicia ComfyUI tras instalar dependencias.
- En Jupyter/Vast.ai: accede a `http://proxy/8188/` y busca "chelogarcho".
- Si no ves los nodos, revisa el log de arranque: se listan al importar el paquete.


## Nodos incluidos

- CL_ImageFidelity (OpenAI): análisis/edición de imágenes
- CL_VirtualTryOn (YourMirror.io): try-on virtual
- CL_GeminiFlash (Gemini 2.5 Flash): generación/edición
- CL_OpenAIChat (OpenAI): análisis y chat con visión

## Uso básico

1) Arrastra el nodo al canvas y pega tu `api_key` en el campo correspondiente.  
2) Conecta entradas/salidas estándar (LoadImage/SaveImage/Preview).  
3) Ejecuta el workflow.

Ejemplos listos: `workflows_examples/` (incluye `combined_workflow_example.json`).

Nota: estos nodos están pensados para ejecutarse dentro de ComfyUI. Algunas dependencias (p. ej., `folder_paths`) existen solo en el entorno de ComfyUI y no fuera de él.

## API keys

- OpenAI: `https://platform.openai.com/api-keys`
- Google (Gemini): `https://aistudio.google.com/app/apikey`
- YourMirror.io: `https://yourmirror.io/`

No se requieren archivos de configuración. Evita compartir workflows con claves embebidas.

## Estructura

```
ComfyUI/
└── custom_nodes/
    └── customNodesChelogarcho/
        ├── __init__.py
        ├── nodes/
        │   ├── CL_ImageFidelity.py
        │   ├── CL_VirtualTryOn.py
        │   ├── CL_GeminiFlash.py
        │   └── CL_OpenAIChat.py
        └── requirements_all_nodes.txt
```

## Resolución de problemas (rápido)

- “API Key is required”: verifica que pegaste una clave válida.
- “Module not found”: reinstala dependencias según `requirements_all_nodes.txt` o vuelve a clonar.
- Verificar importación:
```bash
python -c "import customNodesChelogarcho; print('OK')"
```
- Los nodos aparecen aunque falten dependencias: si una librería falta, verás el nodo, pero fallará al ejecutarlo con un mensaje claro indicando cómo instalar.

## Actualización

```bash
cd customNodesChelogarcho
git pull
```

—

Desarrollado por chelogarcho.
