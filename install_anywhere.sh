#!/bin/bash

echo "🚀 ComfyUI Custom Nodes - Instalador Universal"
echo "👨‍💻 Desarrollado por: chelogarcho"
echo "=================================================="

# Función para encontrar ComfyUI
find_comfyui() {
    local search_paths=(
        "/workspace/ComfyUI"
        "/workspace"
        "/home"
        "/root"
        "$(pwd)"
        "$(pwd)/.."
        "$(pwd)/../.."
        "$(pwd)/../../.."
    )
    
    for path in "${search_paths[@]}"; do
        if [ -d "$path/ComfyUI" ]; then
            echo "$path/ComfyUI"
            return 0
        elif [ -d "$path" ] && [ -f "$path/main.py" ] && [ -d "$path/custom_nodes" ]; then
            echo "$path"
            return 0
        fi
    done
    
    return 1
}

echo "🔍 Buscando ComfyUI en el sistema..."

# Buscar ComfyUI
COMFYUI_DIR=$(find_comfyui)

if [ -z "$COMFYUI_DIR" ]; then
    echo "❌ No se pudo encontrar ComfyUI automáticamente"
    echo "🔍 Buscando manualmente..."
    
    # Buscar en todo el workspace
    if [ -d "/workspace" ]; then
        echo " Buscando en /workspace..."
        COMFYUI_DIR=$(find /workspace -name "ComfyUI" -type d 2>/dev/null | head -1)
    fi
fi

if [ -z "$COMFYUI_DIR" ] || [ ! -d "$COMFYUI_DIR" ]; then
    echo "❌ No se pudo encontrar ComfyUI"
    echo "💡 Asegúrate de que ComfyUI esté instalado en /workspace/ComfyUI"
    exit 1
fi

echo "✅ ComfyUI encontrado en: $COMFYUI_DIR"

# Verificar que sea realmente ComfyUI
if [ ! -d "$COMFYUI_DIR/custom_nodes" ]; then
    echo "❌ El directorio encontrado no parece ser ComfyUI válido"
    exit 1
fi

echo ""
echo "🚀 Instalando dependencias..."

# Encontrar el directorio del proyecto
PROJECT_DIR=""
if [ -f "$(pwd)/install_jupyter.sh" ]; then
    PROJECT_DIR="$(pwd)"
elif [ -f "$(pwd)/customNodesChelogarcho/install_jupyter.sh" ]; then
    PROJECT_DIR="$(pwd)/customNodesChelogarcho"
else
    # Buscar el proyecto
    PROJECT_DIR=$(find /workspace -name "customNodesChelogarcho" -type d 2>/dev/null | head -1)
fi

if [ -z "$PROJECT_DIR" ] || [ ! -d "$PROJECT_DIR" ]; then
    echo "❌ No se pudo encontrar el proyecto customNodesChelogarcho"
    exit 1
fi

echo "✅ Proyecto encontrado en: $PROJECT_DIR"

# Instalar dependencias
if [ -f "$PROJECT_DIR/requirements_all_nodes.txt" ]; then
    echo "📦 Instalando dependencias..."
    pip install --upgrade pip setuptools wheel --quiet
    pip install -r "$PROJECT_DIR/requirements_all_nodes.txt" --quiet --no-cache-dir
    echo "✅ Dependencias instaladas"
fi

echo ""
echo "📁 Copiando archivos únicos..."

# Lista de archivos a copiar
SINGLE_FILES=(
    "CL_ImageFidelity.py"
    "CL_VirtualTryOn.py"
    "CL_GeminiFlash.py"
    "CL_OpenAIChat.py"
)

# Copiar archivos
SUCCESS_COUNT=0
for file in "${SINGLE_FILES[@]}"; do
    if [ -f "$PROJECT_DIR/nodes/$file" ]; then
        cp "$PROJECT_DIR/nodes/$file" "$COMFYUI_DIR/custom_nodes/"
        if [ $? -eq 0 ]; then
            echo "✅ $file copiado exitosamente"
            ((SUCCESS_COUNT++))
        else
            echo "❌ Error copiando $file"
        fi
    else
        echo "❌ $file no encontrado en $PROJECT_DIR/nodes/"
    fi
done

echo ""
echo "=================================================="
echo "📊 RESUMEN DE INSTALACIÓN"
echo "=================================================="
echo " Archivos copiados: $SUCCESS_COUNT/${#SINGLE_FILES[@]}"
echo " Ubicación destino: $COMFYUI_DIR/custom_nodes/"

if [ $SUCCESS_COUNT -eq ${#SINGLE_FILES[@]} ]; then
    echo ""
    echo "🎉 ¡INSTALACIÓN COMPLETADA EXITOSAMENTE!"
    echo ""
    echo " ComfyUI está listo para usar!"
    echo "💡 Reinicia ComfyUI para que los cambios surtan efecto"
    echo "🔍 Busca nodos por 'CL_' o 'chelogarcho' en ComfyUI"
    echo " Accede desde: http://proxy/8188/"
    echo ""
    echo "🔑 IMPORTANTE - API Keys Visibles:"
    echo "   - Todos los nodos tienen campos 'api_key' visibles"
    echo "   - No más archivos de configuración necesarios"
    echo ""
    echo "📋 Nodos instalados:"
    for file in "${SINGLE_FILES[@]}"; do
        echo "   ✅ $file"
    done
else
    echo ""
    echo "⚠️ Algunos archivos no se copiaron correctamente"
    echo " Revisa los errores anteriores"
fi

echo ""
echo "=================================================="
echo "👨‍💻 Desarrollado por: chelogarcho"
echo "=================================================="
