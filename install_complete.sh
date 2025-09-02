#!/bin/bash

# 🚀 ComfyUI Custom Nodes - Instalador Completo Automático
# 👨‍💻 Desarrollado por: chelogarcho
# 🌍 Funciona desde cualquier ubicación

set -e  # Salir si hay algún error

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Función para imprimir con colores
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_success() {
    echo -e "${CYAN}[SUCCESS]${NC} $1"
}

print_header() {
    echo -e "${PURPLE}==================================================${NC}"
    echo -e "${PURPLE}$1${NC}"
    echo -e "${PURPLE}==================================================${NC}"
}

# Banner principal
clear
print_header "🚀 INSTALADOR COMPLETO - ComfyUI Custom Nodes"
echo -e "${BLUE}👨‍💻 Desarrollado por: chelogarcho${NC}"
echo -e "${BLUE}🌍 Instalación automática desde cualquier ubicación${NC}"
echo -e "${BLUE}⚡ Optimizado para Vast.ai y Jupyter${NC}"
echo ""

# Función para encontrar ComfyUI
find_comfyui() {
    print_status "🔍 Buscando ComfyUI en el sistema..."
    
    local search_paths=(
        "/workspace/ComfyUI"
        "/workspace"
        "/home"
        "/root"
        "$(pwd)"
        "$(pwd)/.."
        "$(pwd)/../.."
        "$(pwd)/../../.."
        "/opt"
        "/usr/local"
    )
    
    for path in "${search_paths[@]}"; do
        if [ -d "$path/ComfyUI" ] && [ -f "$path/ComfyUI/main.py" ]; then
            echo "$path/ComfyUI"
            return 0
        elif [ -d "$path" ] && [ -f "$path/main.py" ]; then
            echo "$path"
            return 0
        fi
    done
    
    # Buscar recursivamente en workspace
    if [ -d "/workspace" ]; then
        print_status "🔍 Buscando recursivamente en /workspace..."
        local found=$(find /workspace -name "ComfyUI" -type d 2>/dev/null | head -1)
        if [ -n "$found" ] && [ -f "$found/main.py" ]; then
            echo "$found"
            return 0
        fi
    fi
    
    return 1
}

# Función para verificar si es ComfyUI válido
verify_comfyui() {
    local dir="$1"
    if [ -f "$dir/main.py" ]; then
        return 0
    fi
    return 1
}

# Función para crear directorio custom_nodes si no existe
create_custom_nodes_dir() {
    local comfyui_dir="$1"
    if [ ! -d "$comfyui_dir/custom_nodes" ]; then
        print_warning "📁 Directorio custom_nodes no encontrado, creándolo..."
        mkdir -p "$comfyui_dir/custom_nodes"
        print_success "✅ Directorio custom_nodes creado"
    else
        print_success "✅ Directorio custom_nodes ya existe"
    fi
}

# Función para instalar dependencias del sistema
install_system_dependencies() {
    print_status "📦 Verificando dependencias del sistema..."
    
    # Verificar Python
    if ! command -v python3 &> /dev/null && ! command -v python &> /dev/null; then
        print_error "❌ Python no está instalado"
        exit 1
    fi
    
    # Verificar pip
    if ! command -v pip3 &> /dev/null && ! command -v pip &> /dev/null; then
        print_warning "⚠️ pip no está instalado, instalando..."
        if command -v apt-get &> /dev/null; then
            apt-get update -qq
            apt-get install -y python3-pip python3-venv
        elif command -v yum &> /dev/null; then
            yum install -y python3-pip
        fi
    fi
    
    # Verificar git
    if ! command -v git &> /dev/null; then
        print_warning "⚠️ git no está instalado, instalando..."
        if command -v apt-get &> /dev/null; then
            apt-get install -y git
        elif command -v yum &> /dev/null; then
            yum install -y git
        fi
    fi
    
    print_success "✅ Dependencias del sistema verificadas"
}

# Función para clonar el repositorio
clone_repository() {
    local target_dir="$1"
    
    if [ -d "$target_dir/customNodesChelogarcho" ]; then
        print_warning "📁 Repositorio ya existe, actualizando..."
        cd "$target_dir/customNodesChelogarcho"
        git pull origin main --quiet
        print_success "✅ Repositorio actualizado"
    else
        print_status "📥 Clonando repositorio desde GitHub..."
        cd "$target_dir"
        git clone https://github.com/donchelo/customNodesChelogarcho.git --quiet
        print_success "✅ Repositorio clonado exitosamente"
    fi
}

# Función para instalar dependencias Python
install_python_dependencies() {
    local project_dir="$1"
    
    if [ -f "$project_dir/requirements_all_nodes.txt" ]; then
        print_status "📦 Instalando dependencias Python..."
        
        # Actualizar pip
        python3 -m pip install --upgrade pip setuptools wheel --quiet
        
        # Instalar dependencias
        python3 -m pip install -r "$project_dir/requirements_all_nodes.txt" --quiet --no-cache-dir
        
        print_success "✅ Dependencias Python instaladas"
    else
        print_warning "⚠️ Archivo requirements_all_nodes.txt no encontrado"
    fi
}

# Función para instalar nodos
install_nodes() {
    local project_dir="$1"
    local comfyui_dir="$2"
    
    print_status "📁 Instalando nodos personalizados..."
    
    # Crear directorio si no existe
    create_custom_nodes_dir "$comfyui_dir"
    
    # Lista de nodos a instalar
    local nodes=(
        "CL_ImageFidelity.py"
        "CL_VirtualTryOn.py"
        "CL_GeminiFlash.py"
        "CL_OpenAIChat.py"
    )
    
    local success_count=0
    local total_nodes=${#nodes[@]}
    
    for node in "${nodes[@]}"; do
        local source_file="$project_dir/nodes/$node"
        local target_file="$comfyui_dir/custom_nodes/$node"
        
        if [ -f "$source_file" ]; then
            cp "$source_file" "$target_file"
            if [ $? -eq 0 ]; then
                print_success "✅ $node instalado"
                ((success_count++))
            else
                print_error "❌ Error instalando $node"
            fi
        else
            print_error "❌ $node no encontrado en $source_file"
        fi
    done
    
    # Instalar __init__.py si existe
    if [ -f "$project_dir/__init__.py" ]; then
        cp "$project_dir/__init__.py" "$comfyui_dir/custom_nodes/"
        print_success "✅ __init__.py instalado"
    fi
    
    echo ""
    print_header "📊 RESUMEN DE INSTALACIÓN"
    echo -e "${BLUE}Nodos instalados: $success_count/$total_nodes${NC}"
    echo -e "${BLUE}Ubicación: $comfyui_dir/custom_nodes/${NC}"
    
    if [ $success_count -eq $total_nodes ]; then
        print_success "🎉 ¡INSTALACIÓN COMPLETADA EXITOSAMENTE!"
        return 0
    else
        print_warning "⚠️ Algunos nodos no se instalaron correctamente"
        return 1
    fi
}

# Función para verificar instalación
verify_installation() {
    local comfyui_dir="$1"
    
    print_status "🔍 Verificando instalación..."
    
    local nodes=(
        "CL_ImageFidelity.py"
        "CL_VirtualTryOn.py"
        "CL_GeminiFlash.py"
        "CL_OpenAIChat.py"
    )
    
    local missing_nodes=()
    
    for node in "${nodes[@]}"; do
        if [ ! -f "$comfyui_dir/custom_nodes/$node" ]; then
            missing_nodes+=("$node")
        fi
    done
    
    if [ ${#missing_nodes[@]} -eq 0 ]; then
        print_success "✅ Todos los nodos están instalados correctamente"
        return 0
    else
        print_error "❌ Nodos faltantes: ${missing_nodes[*]}"
        return 1
    fi
}

# Función para mostrar información final
show_final_info() {
    print_header "🎯 INFORMACIÓN FINAL"
    echo ""
    echo -e "${GREEN}🚀 ComfyUI está listo para usar!${NC}"
    echo ""
    echo -e "${BLUE}📱 Acceso desde Jupyter:${NC}"
    echo -e "   URL: ${CYAN}http://proxy/8188/${NC}"
    echo ""
    echo -e "${BLUE}🔍 Cómo usar los nodos:${NC}"
    echo -e "   1. Busca nodos por ${CYAN}'CL_'${NC} o ${CYAN}'chelogarcho'${NC} en ComfyUI"
    echo -e "   2. Arrastra el nodo al canvas"
    echo -e "   3. Configura tu API key en el campo ${CYAN}api_key${NC}"
    echo -e "   4. Ejecuta el workflow"
    echo ""
    echo -e "${BLUE}🔑 API Keys necesarias:${NC}"
    echo -e "   • ${CYAN}CL_ImageFidelity${NC}: OpenAI (https://platform.openai.com/api-keys)"
    echo -e "   • ${CYAN}CL_VirtualTryOn${NC}: YourMirror.io (https://yourmirror.io/)"
    echo -e "   • ${CYAN}CL_GeminiFlash${NC}: Google (https://aistudio.google.com/app/apikey)"
    echo -e "   • ${CYAN}CL_OpenAIChat${NC}: OpenAI (https://platform.openai.com/api-keys)"
    echo ""
    echo -e "${BLUE}⚠️ IMPORTANTE:${NC}"
    echo -e "   • Reinicia ComfyUI para que los cambios surtan efecto"
    echo -e "   • Los nodos tienen campos api_key visibles (no más archivos config)"
    echo -e "   • Funciona inmediatamente después de la instalación"
    echo ""
    print_header "👨‍💻 Desarrollado por: chelogarcho"
}

# Función principal
main() {
    print_status "🚀 Iniciando instalación automática..."
    
    # Instalar dependencias del sistema
    install_system_dependencies
    
    # Buscar ComfyUI
    COMFYUI_DIR=$(find_comfyui)
    
    if [ -z "$COMFYUI_DIR" ]; then
        print_error "❌ No se pudo encontrar ComfyUI"
        echo ""
        echo -e "${YELLOW}💡 Soluciones posibles:${NC}"
        echo -e "   1. Asegúrate de que ComfyUI esté instalado"
        echo -e "   2. Ejecuta este script desde el directorio de ComfyUI"
        echo -e "   3. Verifica que ComfyUI esté en /workspace/ComfyUI"
        exit 1
    fi
    
    print_success "✅ ComfyUI encontrado en: $COMFYUI_DIR"
    
    # Verificar que sea ComfyUI válido
    if ! verify_comfyui "$COMFYUI_DIR"; then
        print_error "❌ El directorio encontrado no es ComfyUI válido"
        exit 1
    fi
    
    # Clonar repositorio
    clone_repository "$COMFYUI_DIR"
    
    # Instalar dependencias Python
    install_python_dependencies "$COMFYUI_DIR/customNodesChelogarcho"
    
    # Instalar nodos
    if install_nodes "$COMFYUI_DIR/customNodesChelogarcho" "$COMFYUI_DIR"; then
        # Verificar instalación
        if verify_installation "$COMFYUI_DIR"; then
            show_final_info
            print_success "🎉 ¡Instalación completada exitosamente!"
            exit 0
        else
            print_error "❌ La instalación no se completó correctamente"
            exit 1
        fi
    else
        print_error "❌ Error durante la instalación de nodos"
        exit 1
    fi
}

# Ejecutar función principal
main "$@"
