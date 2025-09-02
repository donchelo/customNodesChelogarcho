#!/bin/bash

# 🚀 ComfyUI Custom Nodes - Instalador Automático para Jupyter/Vast.ai
# 👨‍💻 Desarrollado por: chelogarcho
# 🌐 Optimizado para Vast.ai con acceso /proxy/8188/
# 🔑 API Keys visibles en cada nodo (no más archivos de configuración)

set -e  # Salir en caso de error

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Funciones de logging
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

echo "=================================================="
echo "🚀 ComfyUI Custom Nodes - Instalador Automático"
echo "👨‍💻 Desarrollado por: chelogarcho"
echo "🌐 Optimizado para Vast.ai con acceso /proxy/8188/"
echo "🔑 API Keys visibles en cada nodo"
echo "=================================================="

# Función para encontrar el directorio ComfyUI
find_comfyui_dir() {
    local current_dir=$(pwd)
    local search_dir="$current_dir"
    
    # Buscar ComfyUI desde el directorio actual hacia arriba
    while [ "$search_dir" != "/" ]; do
        if [ -d "$search_dir/ComfyUI" ]; then
            echo "$search_dir/ComfyUI"
            return 0
        fi
        search_dir=$(dirname "$search_dir")
    done
    
    # Si no se encuentra, buscar en el directorio actual
    if [ -d "$current_dir/ComfyUI" ]; then
        echo "$current_dir/ComfyUI"
        return 0
    fi
    
    # Si no se encuentra, buscar en directorios padre
    if [ -d "$current_dir/../ComfyUI" ]; then
        echo "$current_dir/../ComfyUI"
        return 0
    fi
    
    if [ -d "$current_dir/../../ComfyUI" ]; then
        echo "$current_dir/../../ComfyUI"
        return 0
    fi
    
    return 1
}

# Función para encontrar el directorio del proyecto
find_project_dir() {
    local current_dir=$(pwd)
    log_info "🔍 Buscando proyecto desde: $current_dir"
    
    # Si estamos en el directorio del proyecto
    if [ -f "$current_dir/install_jupyter.sh" ] && [ -d "$current_dir/nodes" ]; then
        log_info "✅ Proyecto encontrado en directorio actual"
        echo "$current_dir"
        return 0
    fi
    
    # Si estamos en custom_nodes/customNodesChelogarcho
    if [ -f "$current_dir/install_jupyter.sh" ] && [ -d "$current_dir/nodes" ]; then
        log_info "✅ Proyecto encontrado en directorio actual (custom_nodes)"
        echo "$current_dir"
        return 0
    fi
    
    # Buscar en directorios padre
    if [ -f "$current_dir/../install_jupyter.sh" ] && [ -d "$current_dir/../nodes" ]; then
        log_info "✅ Proyecto encontrado en directorio padre"
        echo "$current_dir/.."
        return 0
    fi
    
    if [ -f "$current_dir/../../install_jupyter.sh" ] && [ -d "$current_dir/../../nodes" ]; then
        log_info "✅ Proyecto encontrado en directorio padre del padre"
        echo "$current_dir/../.."
        return 0
    fi
    
    # Buscar desde ComfyUI hacia abajo
    if [ -d "$current_dir/custom_nodes/customNodesChelogarcho" ]; then
        log_info "🔍 Verificando custom_nodes/customNodesChelogarcho..."
        if [ -f "$current_dir/custom_nodes/customNodesChelogarcho/install_jupyter.sh" ] && [ -d "$current_dir/custom_nodes/customNodesChelogarcho/nodes" ]; then
            log_info "✅ Proyecto encontrado en custom_nodes/customNodesChelogarcho"
            echo "$current_dir/custom_nodes/customNodesChelogarcho"
            return 0
        else
            log_warning "⚠️ Directorio existe pero no tiene estructura correcta"
        fi
    fi
    
    # Buscar en directorios padre desde ComfyUI
    if [ -d "$current_dir/../custom_nodes/customNodesChelogarcho" ]; then
        log_info "🔍 Verificando ../custom_nodes/customNodesChelogarcho..."
        if [ -f "$current_dir/../custom_nodes/customNodesChelogarcho/install_jupyter.sh" ] && [ -d "$current_dir/../custom_nodes/customNodesChelogarcho/nodes" ]; then
            log_info "✅ Proyecto encontrado en ../custom_nodes/customNodesChelogarcho"
            echo "$current_dir/../custom_nodes/customNodesChelogarcho"
            return 0
        fi
    fi
    
    if [ -d "$current_dir/../../custom_nodes/customNodesChelogarcho" ]; then
        log_info "🔍 Verificando ../../custom_nodes/customNodesChelogarcho..."
        if [ -f "$current_dir/../../custom_nodes/customNodesChelogarcho/install_jupyter.sh" ] && [ -d "$current_dir/../../custom_nodes/customNodesChelogarcho/nodes" ]; then
            log_info "✅ Proyecto encontrado en ../../custom_nodes/customNodesChelogarcho"
            echo "$current_dir/../../custom_nodes/customNodesChelogarcho"
            return 0
        fi
    fi
    
    log_error "❌ No se pudo encontrar el proyecto en ninguna ubicación"
    return 1
}

# Función principal de instalación
main_installation() {
    log_info "🔍 Detectando directorios..."
    
    # Encontrar directorio ComfyUI
    local comfyui_dir
    if comfyui_dir=$(find_comfyui_dir); then
        log_success "✅ ComfyUI encontrado en: $comfyui_dir"
    else
        log_error "❌ No se pudo encontrar ComfyUI. Asegúrate de estar en el directorio correcto."
        exit 1
    fi
    
    # Encontrar directorio del proyecto
    local project_dir
    if project_dir=$(find_project_dir); then
        log_success "✅ Proyecto encontrado en: $project_dir"
    else
        log_error "❌ No se pudo encontrar el proyecto customNodesChelogarcho."
        exit 1
    fi
    
    # Cambiar al directorio ComfyUI
    cd "$comfyui_dir"
    log_info "📁 Cambiando a directorio ComfyUI: $(pwd)"
    
    # Verificar que custom_nodes existe
    if [ ! -d "custom_nodes" ]; then
        log_error "❌ No se encontró el directorio 'custom_nodes' en ComfyUI."
        exit 1
    fi
    
    # Verificar que el proyecto esté en custom_nodes
    local project_in_custom_nodes="$comfyui_dir/custom_nodes/customNodesChelogarcho"
    if [ ! -d "$project_in_custom_nodes" ]; then
        log_error "❌ No se encontró customNodesChelogarcho en custom_nodes. Clona primero el repositorio."
        exit 1
    fi
    
    # Instalar dependencias principales
    log_info "📦 Instalando dependencias principales..."
    cd "$project_in_custom_nodes"
    
    if pip install -r requirements_all_nodes.txt --quiet --no-cache-dir; then
        log_success "✅ Dependencias principales instaladas"
    else
        log_warning "⚠️ Error instalando dependencias principales, continuando..."
    fi
    
    # Volver al directorio ComfyUI
    cd "$comfyui_dir"
    
    # Lista de nodos disponibles
    local NODES=("CL_GeminiFlash" "CL_ImageFidelity" "CL_VirtualTryOn" "CL_OpenAIChat")
    
    # Instalar nodos como paquetes
    log_info "🔧 Instalando nodos como paquetes..."
    
    for node in "${NODES[@]}"; do
        log_info "📋 Instalando $node..."
        
        # Crear directorio del nodo
        mkdir -p "custom_nodes/$node"
        
        # Copiar archivo del nodo
        if [ -f "custom_nodes/customNodesChelogarcho/nodes/$node.py" ]; then
            cp "custom_nodes/customNodesChelogarcho/nodes/$node.py" "custom_nodes/$node/"
            
            # Copiar __init__.py
            if [ -f "custom_nodes/customNodesChelogarcho/__init__.py" ]; then
                cp "custom_nodes/customNodesChelogarcho/__init__.py" "custom_nodes/$node/"
            fi
            
            # Copiar requirements como requirements.txt del nodo
            if [ -f "custom_nodes/customNodesChelogarcho/requirements_all_nodes.txt" ]; then
                cp "custom_nodes/customNodesChelogarcho/requirements_all_nodes.txt" "custom_nodes/$node/requirements.txt"
            fi
            
            log_success "✅ $node instalado correctamente"
        else
            log_error "❌ Archivo fuente para $node no encontrado"
        fi
    done
    
    # Verificar instalación final
    echo ""
    echo "=================================================="
    echo "🔍 Verificando instalación..."
    echo "=================================================="
    
    local all_installed=true
    for node in "${NODES[@]}"; do
        if [ -d "custom_nodes/$node" ] && [ -f "custom_nodes/$node/$node.py" ]; then
            log_success "✅ $node instalado correctamente"
        else
            log_error "❌ $node no se instaló correctamente"
            all_installed=false
        fi
    done
    
    echo ""
    echo "=================================================="
    if [ "$all_installed" = true ]; then
        echo "🎉 ¡Instalación completada exitosamente!"
        log_success "Todos los nodos están listos para usar"
    else
        echo "⚠️ Instalación completada con advertencias"
        log_warning "Algunos nodos pueden no funcionar correctamente"
    fi
    
    echo ""
    echo "🚀 ComfyUI está listo para usar!"
    echo "💡 Reinicia ComfyUI para que los cambios surtan efecto"
    echo "🔍 Busca nodos por 'CL_' o 'chelogarcho' en ComfyUI"
    echo "🌐 Accede desde: http://proxy/8188/"
    echo "=================================================="
}

# Función para instalación ultra-simple
ultra_simple_installation() {
    log_info "📁 Instalación Ultra-Simple activada..."
    
    # Encontrar directorio del proyecto
    local project_dir
    if project_dir=$(find_project_dir); then
        log_success "✅ Proyecto encontrado en: $project_dir"
    else
        log_error "❌ No se pudo encontrar el proyecto."
        exit 1
    fi
    
    # Cambiar al directorio del proyecto
    cd "$project_dir"
    
    # Encontrar ComfyUI
    local comfyui_dir
    if comfyui_dir=$(find_comfyui_dir); then
        log_success "✅ ComfyUI encontrado en: $comfyui_dir"
    else
        log_error "❌ No se pudo encontrar ComfyUI."
        exit 1
    fi
    
    # Instalar dependencias
    log_info "📦 Instalando dependencias..."
    if pip install -r requirements_all_nodes.txt --quiet --no-cache-dir; then
        log_success "✅ Dependencias instaladas"
    else
        log_warning "⚠️ Error instalando dependencias, continuando..."
    fi
    
    # Copiar paquete completo
    log_info "📋 Copiando paquete completo..."
    if [ -d "$comfyui_dir/custom_nodes" ]; then
        cp -r . "$comfyui_dir/custom_nodes/"
        log_success "✅ Paquete completo copiado"
    else
        log_error "❌ No se pudo acceder al directorio custom_nodes"
        exit 1
    fi
    
    echo ""
    echo "=================================================="
    echo "🎉 ¡Instalación Ultra-Simple completada!"
    echo ""
    echo "🚀 ComfyUI está listo para usar!"
    echo "💡 Reinicia ComfyUI para que los cambios surtan efecto"
    echo "🔍 Busca nodos por 'CL_' o 'chelogarcho' en ComfyUI"
    echo "🌐 Accede desde: http://proxy/8188/"
    echo "=================================================="
}

# Verificar argumentos
if [ "$1" = "--ultra-simple" ]; then
    ultra_simple_installation
else
    main_installation
fi
