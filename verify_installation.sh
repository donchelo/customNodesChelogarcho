#!/bin/bash

# Script para verificar la instalación de custom nodes
echo "🔍 Verificando instalación de custom nodes..."

# Navegar al directorio de ComfyUI
cd ComfyUI

echo "📁 Directorio actual: $(pwd)"

# Verificar que los directorios existen
echo ""
echo "📂 Verificando estructura de directorios:"

custom_nodes_dirs=("inputFidelity" "mirrorNode" "openai_simple_chat")

for dir in "${custom_nodes_dirs[@]}"; do
    if [ -d "custom_nodes/$dir" ]; then
        echo "✅ custom_nodes/$dir - Existe"
        
        # Verificar archivos esenciales
        if [ -f "custom_nodes/$dir/__init__.py" ]; then
            echo "   ✅ __init__.py - Existe"
        else
            echo "   ❌ __init__.py - Faltante"
        fi
        
        if [ -f "custom_nodes/$dir/requirements.txt" ]; then
            echo "   ✅ requirements.txt - Existe"
        else
            echo "   ℹ️  requirements.txt - No encontrado"
        fi
        
        if [ -f "custom_nodes/$dir/README.md" ]; then
            echo "   ✅ README.md - Existe"
        else
            echo "   ℹ️  README.md - No encontrado"
        fi
    else
        echo "❌ custom_nodes/$dir - No existe"
    fi
done

# Verificar dependencias instaladas
echo ""
echo "📦 Verificando dependencias instaladas:"

# Lista de paquetes importantes
important_packages=("openai" "pillow" "torch" "numpy" "requests" "typing-extensions" "langdetect")

for package in "${important_packages[@]}"; do
    if pip show "$package" > /dev/null 2>&1; then
        version=$(pip show "$package" | grep Version | cut -d' ' -f2)
        echo "✅ $package - Versión $version"
    else
        echo "❌ $package - No instalado"
    fi
done

# Verificar que ComfyUI puede importar los custom nodes
echo ""
echo "🔧 Verificando importación de custom nodes:"

python3 -c "
import sys
sys.path.append('custom_nodes')

try:
    import inputFidelity
    print('✅ inputFidelity - Importación exitosa')
except ImportError as e:
    print(f'❌ inputFidelity - Error de importación: {e}')

try:
    import mirrorNode
    print('✅ mirrorNode - Importación exitosa')
except ImportError as e:
    print(f'❌ mirrorNode - Error de importación: {e}')

try:
    import openai_simple_chat
    print('✅ openai_simple_chat - Importación exitosa')
except ImportError as e:
    print(f'❌ openai_simple_chat - Error de importación: {e}')
"

echo ""
echo "🎯 Resumen de verificación:"
echo "   • Si todos los directorios existen ✅"
echo "   • Si todas las dependencias están instaladas ✅"
echo "   • Si la importación es exitosa ✅"
echo ""
echo "🚀 Los custom nodes deberían estar disponibles en ComfyUI"
echo "   Accede a: /proxy/8188/ y busca en la sección 'Custom Nodes'"
