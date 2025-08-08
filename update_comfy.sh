#!/usr/bin/env bash
set -euo pipefail

# Configuración
COMFY_REPO_URL="https://github.com/comfyanonymous/ComfyUI.git"
# Puedes sobreescribir estas variables vía entorno: COMFY_DIR, VENV_PATH, PORT
COMFY_DIR="${COMFY_DIR:-/workspace/ComfyUI}"
VENV_PATH="${VENV_PATH:-$COMFY_DIR/.venv}"
PORT="${PORT:-8188}"

echo "🧠 Configurando git safe.directory para $COMFY_DIR"
git config --global --add safe.directory "$COMFY_DIR" || true

if [ ! -d "$COMFY_DIR/.git" ]; then
  echo "📥 Clonando ComfyUI en $COMFY_DIR"
  mkdir -p "$(dirname "$COMFY_DIR")"
  git clone --depth=1 "$COMFY_REPO_URL" "$COMFY_DIR"
else
  echo "📦 Actualizando ComfyUI existente"
  cd "$COMFY_DIR"
  git fetch origin
  # Fuerza a la rama principal y sincroniza con remoto
  git checkout master
  git reset --hard origin/master
fi

echo "🐍 Preparando entorno virtual en $VENV_PATH"
if [ ! -d "$VENV_PATH" ]; then
  python3 -m venv "$VENV_PATH"
fi
source "$VENV_PATH/bin/activate"
python -m pip install --upgrade pip

echo "🔧 Instalando/actualizando dependencias de ComfyUI"
# Nota: PyTorch suele instalarse aparte. Aquí mantenemos lo que defina requirements.txt
pip install --upgrade -r "$COMFY_DIR/requirements.txt"

echo "🧩 Actualizando custom_nodes (si existen)"
CUSTOM_DIR="$COMFY_DIR/custom_nodes"
if [ -d "$CUSTOM_DIR" ]; then
  cd "$CUSTOM_DIR"
  for d in */ ; do
    [ -d "$d" ] || continue
    if [ -d "$d/.git" ]; then
      echo "➡️ git pull $d"
      (cd "$d" && git pull --ff-only || true)
      if [ -f "$d/requirements.txt" ]; then
        echo "   📦 pip install -r $d/requirements.txt"
        pip install -r "$d/requirements.txt" || true
      fi
    else
      echo "⏭️ Saltando $d (no es repo git)"
    fi
  done
else
  echo "⚠️ No hay carpeta custom_nodes (se omite)"
fi

echo "🛑 Cerrando procesos antiguos de ComfyUI (si existen)"
pkill -f "python .*main.py" 2>/dev/null || echo "(no había procesos)"

echo "🚀 Lanzando ComfyUI en background en puerto $PORT"
cd "$COMFY_DIR"
nohup python main.py \
  --listen \
  --port "$PORT" \
  --front-end-version Comfy-Org/ComfyUI_frontend@latest \
  > "$COMFY_DIR/comfy.log" 2>&1 &

echo "✅ Listo. Accede vía proxy de Jupyter: /proxy/$PORT/"
