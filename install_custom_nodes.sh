#!/bin/bash

# Script para instalar custom nodes de ComfyUI
# Ejecutar desde la terminal de Jupyter

echo "🚀 Iniciando instalación de custom nodes para ComfyUI..."

# Verificar que estamos en el directorio correcto
if [ ! -d "ComfyUI" ]; then
    echo "❌ Error: No se encontró el directorio ComfyUI"
    echo "Por favor, ejecuta este script desde el directorio raíz del proyecto"
    exit 1
fi

# Navegar al directorio de ComfyUI
cd ComfyUI

# Verificar que existe el directorio custom_nodes
if [ ! -d "custom_nodes" ]; then
    echo "❌ Error: No se encontró el directorio custom_nodes"
    exit 1
fi

echo "📁 Directorio de trabajo: $(pwd)"

# Función para instalar dependencias de un custom node
install_node_dependencies() {
    local node_dir=$1
    local node_name=$2
    
    echo "🔧 Instalando dependencias para $node_name..."
    
    if [ -f "$node_dir/requirements.txt" ]; then
        echo "📦 Instalando paquetes desde requirements.txt..."
        pip install -r "$node_dir/requirements.txt"
        
        if [ $? -eq 0 ]; then
            echo "✅ Dependencias instaladas correctamente para $node_name"
        else
            echo "⚠️  Advertencia: Algunas dependencias no se pudieron instalar para $node_name"
        fi
    else
        echo "ℹ️  No se encontró requirements.txt para $node_name"
    fi
}

# Lista de custom nodes a instalar
declare -A custom_nodes=(
    ["inputFidelity"]="Input Fidelity (OpenAI Image Analysis)"
    ["mirrorNode"]="Mirror Node (Virtual Try-On)"
    ["openai_simple_chat"]="OpenAI Simple Chat"
)

# Instalar cada custom node
for node_dir in "${!custom_nodes[@]}"; do
    node_name="${custom_nodes[$node_dir]}"
    
    if [ -d "custom_nodes/$node_dir" ]; then
        echo ""
        echo "🎯 Instalando $node_name..."
        echo "📂 Directorio: custom_nodes/$node_dir"
        
        # Verificar que el custom node tiene la estructura correcta
        if [ -f "custom_nodes/$node_dir/__init__.py" ]; then
            echo "✅ Estructura del custom node válida"
            
            # Instalar dependencias
            install_node_dependencies "custom_nodes/$node_dir" "$node_name"
            
            # Verificar archivos principales
            if [ -f "custom_nodes/$node_dir/README.md" ]; then
                echo "📖 README encontrado"
            fi
            
            echo "✅ $node_name instalado correctamente"
        else
            echo "❌ Error: $node_name no tiene un archivo __init__.py válido"
        fi
    else
        echo "❌ Error: No se encontró el directorio custom_nodes/$node_dir"
    fi
done

echo ""
echo "🎉 ¡Instalación completada!"
echo ""
echo "📋 Resumen de custom nodes instalados:"
echo "   • Input Fidelity - Análisis de imágenes con OpenAI"
echo "   • Mirror Node - Virtual Try-On"
echo "   • OpenAI Simple Chat - Chat integrado con OpenAI"
echo ""
echo "🔄 Para que los cambios surtan efecto:"
echo "   1. Reinicia ComfyUI si está ejecutándose"
echo "   2. Los custom nodes aparecerán en la sección 'Custom Nodes'"
echo "   3. Si usas Jupyter, accede a ComfyUI en: /proxy/8188/"
echo ""
echo "🔧 Si encuentras problemas:"
echo "   • Verifica que todas las dependencias se instalaron: pip list"
echo "   • Revisa los logs de ComfyUI para errores"
echo "   • Asegúrate de tener configuradas las API keys necesarias"
