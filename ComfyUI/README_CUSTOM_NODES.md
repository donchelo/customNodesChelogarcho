# Custom Nodes para ComfyUI

Este repositorio contiene tres custom nodes especializados para ComfyUI:

## 🎯 Custom Nodes Disponibles

### 1. **OpenAIImageFidelityFashion** 
- **Función**: Análisis y mejora de fidelidad de imágenes usando OpenAI
- **Especializado en**: Moda y fotografía de productos
- **Características**: 
  - Alta fidelidad de entrada
  - Presets especializados para moda
  - Control de iteraciones
  - Soporte para máscaras y imágenes de referencia

### 2. **MirrorNode**
- **Función**: Crear efectos de espejo en imágenes
- **Características**:
  - Espejo horizontal y vertical
  - Configuración personalizable
  - Procesamiento rápido

### 3. **OpenAISimpleChat**
- **Función**: Chat con OpenAI usando Responses API
- **Características**:
  - Soporte para texto + imágenes
  - Detección automática de idioma
  - Respuestas siempre en inglés
  - Límite configurable de caracteres

## 🚀 Instalación Automática

### Opción 1: Script Automático (Recomendado)

```bash
# 1. Navegar al directorio de ComfyUI
cd /workspace/ComfyUI

# 2. Ejecutar el script de instalación
chmod +x install_custom_nodes.sh
./install_custom_nodes.sh
```

El script automáticamente:
- ✅ Descarga los custom nodes desde GitHub
- ✅ Instala todas las dependencias
- ✅ Configura la API key de OpenAI
- ✅ Verifica la instalación

### Opción 2: Instalación Manual

```bash
# 1. Descargar custom nodes
cd /workspace/ComfyUI
git clone https://github.com/donchelo/ComfyUI.git temp_repo
cp -r temp_repo/ComfyUI/custom_nodes/* custom_nodes/
rm -rf temp_repo

# 2. Instalar dependencias
pip install -r custom_nodes/inputFidelity/requirements.txt
pip install -r custom_nodes/mirrorNode/requirements.txt
pip install -r custom_nodes/openai_simple_chat/requirements.txt

# 3. Configurar API key
echo "OPENAI_API_KEY=tu_clave_api_aqui" > custom_nodes/inputFidelity/config.env
echo "OPENAI_API_KEY=tu_clave_api_aqui" > custom_nodes/openai_simple_chat/.env
```

## 🔑 Configuración de API Key

### Para inputFidelity:
```bash
echo "OPENAI_API_KEY=sk-proj-..." > custom_nodes/inputFidelity/config.env
```

### Para openai_simple_chat:
```bash
echo "OPENAI_API_KEY=sk-proj-..." > custom_nodes/openai_simple_chat/.env
```

### Variable de entorno (opcional):
```bash
export OPENAI_API_KEY="sk-proj-..."
echo 'export OPENAI_API_KEY="sk-proj-..."' >> ~/.bashrc
```

## 🔧 Uso

### 1. Reiniciar ComfyUI
Después de la instalación, reinicia ComfyUI para que detecte los nuevos custom nodes.

### 2. Encontrar los Custom Nodes
- Haz clic derecho en el canvas de ComfyUI
- Busca en la sección "Custom Nodes"
- Selecciona el custom node que necesites

### 3. Configurar los Nodes

#### OpenAIImageFidelityFashion:
- **Prompt**: Descripción de los cambios deseados
- **Primary Image**: Imagen principal a procesar
- **Input Fidelity**: "high" para mejor calidad
- **Fashion Preset**: Selecciona el tipo de modificación

#### MirrorNode:
- **Image**: Imagen a reflejar
- **Direction**: Horizontal o vertical

#### OpenAISimpleChat:
- **User Prompt**: Tu pregunta o instrucción
- **Model**: Modelo de OpenAI a usar
- **Use Env Key**: Marca para usar la API key configurada

## 🐛 Solución de Problemas

### Error: "OPENAI_API_KEY no encontrada"

**Solución 1**: Verificar archivos de configuración
```bash
cat custom_nodes/inputFidelity/config.env
cat custom_nodes/openai_simple_chat/.env
```

**Solución 2**: Crear archivos de configuración
```bash
echo "OPENAI_API_KEY=tu_clave_api_aqui" > custom_nodes/inputFidelity/config.env
echo "OPENAI_API_KEY=tu_clave_api_aqui" > custom_nodes/openai_simple_chat/.env
```

**Solución 3**: Configurar variable de entorno
```bash
export OPENAI_API_KEY="tu_clave_api_aqui"
```

### Error: "Custom node no encontrado"

**Solución**: Reiniciar ComfyUI
```bash
# Detener ComfyUI (Ctrl+C)
# Reiniciar ComfyUI
python main.py
```

### Error: "Dependencias faltantes"

**Solución**: Instalar dependencias
```bash
pip install -r custom_nodes/inputFidelity/requirements.txt
pip install -r custom_nodes/mirrorNode/requirements.txt
pip install -r custom_nodes/openai_simple_chat/requirements.txt
```

## 📁 Estructura de Archivos

```
ComfyUI/
├── custom_nodes/
│   ├── inputFidelity/
│   │   ├── openai_image_fidelity_fashion.py
│   │   ├── config.env
│   │   └── requirements.txt
│   ├── mirrorNode/
│   │   ├── mirror_node.py
│   │   └── requirements.txt
│   └── openai_simple_chat/
│       ├── openai_simple_chat.py
│       ├── .env
│       └── requirements.txt
├── install_custom_nodes.sh
└── README_CUSTOM_NODES.md
```

## 🔄 Actualización

Para actualizar los custom nodes:

```bash
# Opción 1: Usar el script
./install_custom_nodes.sh

# Opción 2: Manual
cd /workspace/ComfyUI
git clone https://github.com/donchelo/ComfyUI.git temp_repo
cp -r temp_repo/ComfyUI/custom_nodes/* custom_nodes/
rm -rf temp_repo
```

## 📞 Soporte

Si tienes problemas:
1. Verifica que todos los archivos están en su lugar
2. Revisa los logs de ComfyUI para errores específicos
3. Asegúrate de que la API key está configurada correctamente
4. Reinicia ComfyUI después de cualquier cambio

## 📝 Notas

- Los custom nodes están optimizados para entornos Vast.ai con Jupyter
- La API key se puede configurar de múltiples formas para mayor flexibilidad
- Todos los custom nodes incluyen logging detallado para facilitar la depuración
