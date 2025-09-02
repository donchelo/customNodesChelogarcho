#!/bin/bash

# ComfyUI Custom Nodes - Instalador Automático
# Desarrollado por: chelogarcho
# Script para instalar todos los custom nodes automáticamente

set -e  # Salir si hay algún error

echo "🚀 ComfyUI Custom Nodes - Instalador Automático"
echo "👨‍💻 Desarrollado por: chelogarcho"
echo "=================================================="

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para logging
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Verificar que estamos en el directorio correcto
if [ ! -d "custom_nodes" ]; then
    log_error "No se encontró el directorio 'custom_nodes'. Ejecuta este script desde la raíz de ComfyUI."
    exit 1
fi

# Verificar Python
if ! command -v python3 &> /dev/null; then
    log_error "Python3 no está instalado. Por favor instala Python 3.8+"
    exit 1
fi

PYTHON_VERSION=$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[:2])))')
log_info "Python version: $PYTHON_VERSION"

# Verificar pip
if ! command -v pip3 &> /dev/null; then
    log_error "pip3 no está instalado. Por favor instala pip3"
    exit 1
fi

# Función para instalar dependencias de un nodo
install_node_dependencies() {
    local node_name=$1
    local requirements_file="custom_nodes/$node_name/requirements.txt"
    
    if [ -f "$requirements_file" ]; then
        log_info "Instalando dependencias para $node_name..."
        if pip3 install -r "$requirements_file" --quiet; then
            log_success "Dependencias de $node_name instaladas correctamente"
        else
            log_warning "Error instalando dependencias de $node_name, continuando..."
        fi
    else
        log_warning "No se encontró requirements.txt para $node_name"
    fi
}

# Función para verificar instalación de un nodo
verify_node_installation() {
    local node_name=$1
    local init_file="custom_nodes/$node_name/__init__.py"
    
    if [ -f "$init_file" ]; then
        log_success "✅ $node_name está listo"
        return 0
    else
        log_error "❌ $node_name no se instaló correctamente"
        return 1
    fi
}

# Lista de nodos a instalar
NODES=(
    "inputFidelity"
    "mirrorNode" 
    "bananaNode"
    "openai_simple_chat"
)

# Instalar dependencias del sistema
log_info "Instalando dependencias del sistema..."
pip3 install --upgrade pip setuptools wheel

# Instalar dependencias de cada nodo
log_info "Instalando dependencias de todos los nodos..."
for node in "${NODES[@]}"; do
    if [ -d "custom_nodes/$node" ]; then
        install_node_dependencies "$node"
    else
        log_warning "Directorio $node no encontrado"
    fi
done

# Verificar instalación
log_info "Verificando instalación de nodos..."
INSTALLATION_SUCCESS=true

for node in "${NODES[@]}"; do
    if ! verify_node_installation "$node"; then
        INSTALLATION_SUCCESS=false
    fi
done

echo ""
echo "=================================================="
if [ "$INSTALLATION_SUCCESS" = true ]; then
    log_success "🎉 ¡Todos los custom nodes se instalaron correctamente!"
    echo ""
    echo "📋 Nodos instalados:"
    for node in "${NODES[@]}"; do
        echo "   ✅ $node"
    done
    echo ""
    echo "🚀 ComfyUI está listo para usar con tus custom nodes!"
    echo "💡 Reinicia ComfyUI para que los cambios surtan efecto"
else
    log_error "❌ Algunos nodos no se instalaron correctamente"
    echo "🔍 Revisa los logs anteriores para más detalles"
    exit 1
fi

echo ""
echo "📚 Recursos adicionales:"
echo "   - README_CUSTOM_NODES.md: Documentación de cada nodo"
echo "   - workflows_examples/: Ejemplos de uso"
echo "   - custom_nodes/*/README.md: Documentación específica de cada nodo"
echo ""
echo "👨‍💻 Desarrollado por: chelogarcho"
echo "=================================================="
