#!/bin/bash

echo "========================================"
echo "LIMPIEZA DE ESTRUCTURA ANTIGUA"
echo "========================================"
echo
echo "Este script eliminara la estructura antigua de nodos"
echo "y dejara solo los archivos unicos nuevos."
echo

read -p "¿Continuar? (s/n): " confirm
if [[ $confirm != [sS] ]]; then
    echo "Operacion cancelada."
    exit 0
fi

echo
echo "Eliminando directorios antiguos..."

if [ -d "custom_nodes/inputFidelity" ]; then
    echo "- Eliminando inputFidelity..."
    rm -rf "custom_nodes/inputFidelity"
fi

if [ -d "custom_nodes/mirrorNode" ]; then
    echo "- Eliminando mirrorNode..."
    rm -rf "custom_nodes/mirrorNode"
fi

if [ -d "custom_nodes/bananaNode" ]; then
    echo "- Eliminando bananaNode..."
    rm -rf "custom_nodes/bananaNode"
fi

if [ -d "custom_nodes/openai_simple_chat" ]; then
    echo "- Eliminando openai_simple_chat..."
    rm -rf "custom_nodes/openai_simple_chat"
fi

echo
echo "Limpieza completada!"
echo
echo "Estructura nueva mantenida:"
echo "- nodes/CL_ImageFidelity.py"
echo "- nodes/CL_VirtualTryOn.py"
echo "- nodes/CL_GeminiFlash.py"
echo "- nodes/CL_OpenAIChat.py"
echo
echo "Archivos de instalacion mantenidos:"
echo "- install_jupyter.sh"
echo "- install_jupyter.bat"
echo "- README.md"
echo "- requirements_all_nodes.txt"
echo
