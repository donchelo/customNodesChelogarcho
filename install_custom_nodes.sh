#!/bin/bash

# Script de instalación para custom nodes de ComfyUI
# Autor: donchelo
# Fecha: 2025

echo "🚀 Instalando custom nodes para ComfyUI..."

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para imprimir mensajes con colores
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Verificar que estamos en el directorio correcto
if [ ! -d "custom_nodes" ]; then
    print_error "No se encontró el directorio custom_nodes. Ejecuta este script desde el directorio raíz de ComfyUI."
    exit 1
fi

print_status "Verificando directorio de trabajo..."
print_success "Directorio de ComfyUI encontrado: $(pwd)"

# 1. Descargar custom nodes desde GitHub
print_status "Descargando custom nodes desde GitHub..."
if [ -d "temp_repo" ]; then
    rm -rf temp_repo
fi

git clone https://github.com/donchelo/ComfyUI.git temp_repo
if [ $? -eq 0 ]; then
    cp -r temp_repo/ComfyUI/custom_nodes/* custom_nodes/
    rm -rf temp_repo
    print_success "Custom nodes descargados correctamente"
else
    print_error "Error al descargar custom nodes desde GitHub"
    exit 1
fi

# 2. Instalar dependencias
print_status "Instalando dependencias..."
pip install -r custom_nodes/inputFidelity/requirements.txt
pip install -r custom_nodes/mirrorNode/requirements.txt
pip install -r custom_nodes/openai_simple_chat/requirements.txt
print_success "Dependencias instaladas"

# 3. Configurar API key
print_status "Configurando API key de OpenAI..."

# Solicitar API key al usuario
read -p "Ingresa tu API key de OpenAI (o presiona Enter para usar la variable de entorno): " api_key

if [ -n "$api_key" ]; then
    # Crear archivos de configuración con la API key proporcionada
    echo "OPENAI_API_KEY=$api_key" > custom_nodes/inputFidelity/config.env
    echo "OPENAI_API_KEY=$api_key" > custom_nodes/openai_simple_chat/.env
    
    # También configurar variable de entorno
    export OPENAI_API_KEY="$api_key"
    echo 'export OPENAI_API_KEY="'$api_key'"' >> ~/.bashrc
    
    print_success "API key configurada en archivos de configuración y variable de entorno"
else
    # Verificar si la variable de entorno ya existe
    if [ -n "$OPENAI_API_KEY" ]; then
        print_success "Usando API key de variable de entorno existente"
        echo "OPENAI_API_KEY=$OPENAI_API_KEY" > custom_nodes/inputFidelity/config.env
        echo "OPENAI_API_KEY=$OPENAI_API_KEY" > custom_nodes/openai_simple_chat/.env
    else
        print_warning "No se proporcionó API key. Los custom nodes que requieren OpenAI no funcionarán hasta que configures la API key."
        print_status "Para configurar la API key más tarde, ejecuta:"
        echo "echo 'OPENAI_API_KEY=tu_clave_aqui' > custom_nodes/inputFidelity/config.env"
        echo "echo 'OPENAI_API_KEY=tu_clave_aqui' > custom_nodes/openai_simple_chat/.env"
    fi
fi

# 4. Verificar instalación
print_status "Verificando instalación..."

# Verificar que los custom nodes están presentes
if [ -f "custom_nodes/inputFidelity/openai_image_fidelity_fashion.py" ]; then
    print_success "✅ inputFidelity instalado"
else
    print_error "❌ inputFidelity no encontrado"
fi

if [ -f "custom_nodes/mirrorNode/mirror_node.py" ]; then
    print_success "✅ mirrorNode instalado"
else
    print_error "❌ mirrorNode no encontrado"
fi

if [ -f "custom_nodes/openai_simple_chat/openai_simple_chat.py" ]; then
    print_success "✅ openai_simple_chat instalado"
else
    print_error "❌ openai_simple_chat no encontrado"
fi

# Verificar archivos de configuración
if [ -f "custom_nodes/inputFidelity/config.env" ]; then
    print_success "✅ Configuración de inputFidelity creada"
else
    print_warning "⚠️ Configuración de inputFidelity no encontrada"
fi

if [ -f "custom_nodes/openai_simple_chat/.env" ]; then
    print_success "✅ Configuración de openai_simple_chat creada"
else
    print_warning "⚠️ Configuración de openai_simple_chat no encontrada"
fi

# 5. Información final
echo ""
print_success "🎉 Instalación completada!"
echo ""
print_status "Custom nodes disponibles:"
echo "  • OpenAIImageFidelityFashion - Análisis de fidelidad de imágenes"
echo "  • MirrorNode - Efectos de espejo"
echo "  • OpenAISimpleChat - Chat con OpenAI"
echo ""
print_status "Próximos pasos:"
echo "  1. Reinicia ComfyUI para que detecte los nuevos custom nodes"
echo "  2. Busca los custom nodes en la sección 'Custom Nodes' del menú"
echo "  3. Si no configuraste la API key, hazlo antes de usar los nodes de OpenAI"
echo ""
print_status "Para obtener ayuda, consulta los archivos README.md en cada directorio de custom node"
