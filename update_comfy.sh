#!/bin/bash

# Ruta base
COMFY_DIR="/workspace/ComfyUI"
VENV_PATH="/venv/main"

echo "🧠 Marcando como safe.directory..."
git config --global --add safe.directory "$COMFY_DIR"

echo "📦 Actualizando repositorio principal de ComfyUI..."
cd "$COMFY_DIR" || { echo "❌ No se encontró ComfyUI"; exit 1; }
git pull origin master

echo "🐍 Activando entorno virtual..."
source "$VENV_PATH/bin/activate"

echo "🔧 Instalando dependencias..."
pip install -r requirements.txt --upgrade

echo "🧩 Recorriendo custom_nodes y actualizando..."
cd "$COMFY_DIR/custom_nodes" || { echo "⚠️ No hay carpeta custom_nodes"; exit 1; }

for d in */ ; do
  if [ -d "$d/.git" ]; then
    echo "➡️ Actualizando $d"
    cd "$d" && git pull && cd ..
  else
    echo "⏭️ Saltando $d (no es repositorio git)"
  fi
done

echo "🛑 Cerrando procesos antiguos de ComfyUI (si existen)..."
pkill -f "python main.py" || echo "⚠️ No había procesos corriendo"

echo "🚀 Relanzando ComfyUI..."
cd "$COMFY_DIR"
python main.py
