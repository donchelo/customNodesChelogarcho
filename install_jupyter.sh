#!/bin/bash

# 🚀 ComfyUI Custom Nodes - Instalador Automático para Jupyter/Vast.ai
# Desarrollado por: chelogarcho
# Optimizado para entornos cloud con acceso /proxy/8188/

set -e  # Salir si hay algún error

echo "🚀 ComfyUI Custom Nodes - Instalador Automático para Jupyter/Vast.ai"
echo "👨‍💻 Desarrollado por: chelogarcho"
echo "🌐 Optimizado para Vast.ai con acceso /proxy/8188/"
echo "🔑 API Keys visibles en cada nodo (no más archivos de configuración)"
echo "=================================================="

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
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

log_step() {
    echo -e "${PURPLE}[STEP]${NC} $1"
}

# Verificar argumentos para instalación ultra-simple
if [ "$1" = "--ultra-simple" ]; then
    echo "⚡ Instalación Ultra-Simple activada..."
    echo "🚀 Instalando ComfyUI Custom Nodes..."
    
    # Instalación ultra-simple
    pip install --upgrade pip setuptools wheel --quiet
    pip install -r requirements_all_nodes.txt --quiet --no-cache-dir
    
    echo "✅ Instalación completada! Busca nodos por 'chelogarcho' en ComfyUI"
    echo "🌐 Accede desde: http://proxy/8188/"
    exit 0
fi

# Verificar argumentos para instalación de archivos únicos
if [ "$1" = "--single-files" ]; then
    echo "📁 Instalación de Archivos Únicos activada..."
    echo "🚀 Copiando nodos como archivos únicos a ComfyUI..."
    
    # Verificar que estamos en el directorio correcto
    if [ ! -d "nodes" ]; then
        log_error "❌ No se encontró el directorio 'nodes'. Ejecuta desde el directorio del proyecto."
        exit 1
    fi
    
    # Verificar que estamos en ComfyUI o encontrar ComfyUI
    if [ ! -d "custom_nodes" ]; then
        if [ -d "../ComfyUI/custom_nodes" ]; then
            COMFYUI_DIR="../ComfyUI"
        elif [ -d "../../ComfyUI/custom_nodes" ]; then
            COMFYUI_DIR="../../ComfyUI"
        else
            log_error "❌ No se pudo encontrar ComfyUI. Ejecuta desde ComfyUI o desde el directorio del proyecto."
            exit 1
        fi
    else
        COMFYUI_DIR="."
    fi
    
    # Instalar dependencias
    pip install --upgrade pip setuptools wheel --quiet
    pip install -r requirements_all_nodes.txt --quiet --no-cache-dir
    
    # Copiar archivos únicos
    SINGLE_FILES=(
        "CL_ImageFidelity.py"
        "CL_VirtualTryOn.py"
        "CL_GeminiFlash.py"
        "CL_OpenAIChat.py"
    )
    
    log_info "Copiando archivos únicos a $COMFYUI_DIR/custom_nodes/"
    for file in "${SINGLE_FILES[@]}"; do
        if [ -f "nodes/$file" ]; then
            cp "nodes/$file" "$COMFYUI_DIR/custom_nodes/"
            log_success "✅ $file copiado"
        else
            log_warning "⚠️ $file no encontrado"
        fi
    done
    
    echo ""
    echo "=================================================="
    echo "🎉 ¡Archivos únicos instalados correctamente!"
    echo ""
    echo "📋 Archivos copiados:"
    for file in "${SINGLE_FILES[@]}"; do
        if [ -f "$COMFYUI_DIR/custom_nodes/$file" ]; then
            echo "   ✅ $file"
        fi
    done
    echo ""
    echo "🚀 ComfyUI está listo para usar!"
    echo "💡 Reinicia ComfyUI para que los cambios surtan efecto"
    echo "🔍 Busca nodos por 'CL_' o 'chelogarcho' en ComfyUI"
    echo "🌐 Accede desde: http://proxy/8188/"
    echo "=================================================="
    exit 0
fi

# Verificar que estamos en el directorio correcto
if [ ! -d "custom_nodes" ]; then
    log_warning "⚠️ No se encontró el directorio 'custom_nodes' en el directorio actual."
    log_info "Verificando si estamos en el directorio correcto..."
    
    # Si estamos en el directorio del proyecto, cambiar a ComfyUI
    if [ -d "install_jupyter.sh" ] && [ -d "requirements_all_nodes.txt" ]; then
        log_info "Parece que estamos en el directorio del proyecto. Buscando ComfyUI..."
        
        # Buscar ComfyUI en directorios padre
        if [ -d "../ComfyUI" ]; then
            log_info "Encontrado ComfyUI en directorio padre. Cambiando..."
            cd ../ComfyUI
        elif [ -d "../../ComfyUI" ]; then
            log_info "Encontrado ComfyUI en directorio padre del padre. Cambiando..."
            cd ../../ComfyUI
        else
            log_error "No se pudo encontrar ComfyUI. Ejecuta este script desde la raíz de ComfyUI o desde el directorio del proyecto."
            exit 1
        fi
    else
        log_error "No se encontró el directorio 'custom_nodes'. Ejecuta este script desde la raíz de ComfyUI."
        exit 1
    fi
fi

# Verificar Python
if ! command -v python3 &> /dev/null; then
    if ! command -v python &> /dev/null; then
        log_error "Python no está instalado. Por favor instala Python 3.8+"
        exit 1
    else
        PYTHON_CMD="python"
    fi
else
    PYTHON_CMD="python3"
fi

PYTHON_VERSION=$($PYTHON_CMD -c 'import sys; print(".".join(map(str, sys.version_info[:2])))')
log_info "Python version: $PYTHON_VERSION"

# Verificar pip
if ! command -v pip3 &> /dev/null; then
    if ! command -v pip &> /dev/null; then
        log_error "pip no está instalado. Por favor instala pip"
        exit 1
    else
        PIP_CMD="pip"
    fi
else
    PIP_CMD="pip3"
fi

log_info "Pip command: $PIP_CMD"

# Función para instalar dependencias de un nodo
install_node_dependencies() {
    local node_name=$1
    local requirements_file="custom_nodes/$node_name/requirements.txt"
    
    if [ -f "$requirements_file" ]; then
        log_info "Instalando dependencias para $node_name..."
        if $PIP_CMD install -r "$requirements_file" --quiet --no-cache-dir; then
            log_success "✅ Dependencias de $node_name instaladas"
        else
            log_warning "⚠️ Error instalando dependencias de $node_name, continuando..."
        fi
    else
        log_warning "⚠️ No se encontró requirements.txt para $node_name"
    fi
}

# Función para verificar instalación de un nodo
verify_node_installation() {
    local node_name=$1
    local init_file="custom_nodes/$node_name/__init__.py"
    local main_file="custom_nodes/$node_name/*.py"
    
    if [ -f "$init_file" ] && ls $main_file 1> /dev/null 2>&1; then
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

# Instalación principal
log_step "1. Actualizando dependencias del sistema..."
$PIP_CMD install --upgrade pip setuptools wheel --quiet

log_step "2. Instalando dependencias de todos los nodos..."
for node in "${NODES[@]}"; do
    if [ -d "custom_nodes/$node" ]; then
        install_node_dependencies "$node"
    else
        log_warning "⚠️ Directorio $node no encontrado"
    fi
done

log_step "3. Verificando instalación de nodos..."
INSTALLATION_SUCCESS=true

for node in "${NODES[@]}"; do
    if ! verify_node_installation "$node"; then
        INSTALLATION_SUCCESS=false
    fi
done

# Información final
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
    echo ""
    echo "🌐 Acceso desde Jupyter/Vast.ai:"
    echo "   - URL: http://proxy/8188/"
    echo "   - Busca nodos por 'chelogarcho' en ComfyUI"
    echo ""
    echo "🔑 IMPORTANTE - API Keys Visibles:"
    echo "   - Todos los nodos tienen campos 'api_key' visibles"
    echo "   - No más archivos de configuración necesarios"
    echo "   - Pega tu API key directamente en cada nodo"
    echo ""
    echo "⚡ Opciones de instalación disponibles:"
    echo "   ./install_jupyter.sh --ultra-simple    # Instalación tradicional rápida"
    echo "   ./install_jupyter.sh --single-files    # Instalación de archivos únicos"
else
    log_error "❌ Algunos nodos no se instalaron correctamente"
    echo "🔍 Revisa los logs anteriores para más detalles"
    exit 1
fi

echo ""
echo "📚 Recursos disponibles:"
echo "   - README.md: Documentación completa"
echo "   - workflows_examples/: Ejemplos de uso"
echo ""
echo "🔧 Comandos útiles:"
echo "   - Reiniciar ComfyUI: Reinicia la aplicación"
echo "   - Ver nodos: Busca 'chelogarcho' en ComfyUI"
echo "   - Configurar API: Pega API key en campo 'api_key' del nodo"
echo ""
echo "👨‍💻 Desarrollado por: chelogarcho"
echo "=================================================="
