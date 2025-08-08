# ComfyUI en Jupyter — Guía Rápida

Esta guía explica cómo instalar y ejecutar ComfyUI dentro de Jupyter (Notebook/Lab) y acceder a la interfaz web.

## Requisitos
- Python 3.10 o superior
- Jupyter Notebook/Lab
- (Opcional) GPU NVIDIA con CUDA. Si no tienes GPU, instala la versión CPU de PyTorch.

## Rutas típicas
- Linux/servidor: `/workspace/ComfyUI` (como en servicios tipo Vast.ai)
- Windows: `C:\ruta\a\ComfyUI`

Ajusta los `cd` según tu ruta real.

## Instalación (Terminal de Jupyter)
1) Abre un Terminal desde Jupyter: botón «New» → «Terminal».
2) Ve a la carpeta del proyecto:

```bash
cd /workspace/ComfyUI
# En Windows PowerShell, por ejemplo:
# cd C:\Users\TU_USUARIO\ComfyUI
```

3) Crea y activa un entorno virtual:

- Linux/macOS:
```bash
python3 -m venv .venv
source .venv/bin/activate
```
- Windows (PowerShell):
```powershell
py -3 -m venv .venv
.\.venv\Scripts\Activate.ps1
```

4) Actualiza `pip`:
```bash
python -m pip install --upgrade pip
```

5) Instala PyTorch:
- GPU (CUDA 12.1):
```bash
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121
```
- Solo CPU:
```bash
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu
```

6) Instala el resto de dependencias:
```bash
pip install -r requirements.txt
```

## Lanzar ComfyUI
- Servidor de fondo (recomendado en Jupyter):
```bash
nohup python main.py --listen --port 8188 > comfy.log 2>&1 &
```
- En una celda de Notebook (menos robusto, se detiene si la celda termina):
```bash
!python main.py --listen --port 8188
```

### Acceso a la UI
- Si estás detrás del proxy de Jupyter: abre `…/proxy/8188/` en tu navegador.
  - Ejemplo: `https://TU-SERVIDOR/proxy/8188/`
- Si el puerto está expuesto: `http://IP_DEL_SERVIDOR:8188`

### Detener el servicio
- Linux/macOS:
```bash
pkill -f "python main.py"
```
- Windows PowerShell (mientras el venv esté activo):
```powershell
Get-Process python | Stop-Process
```

### Ver logs
```bash
tail -n 200 -f comfy.log
```

## Dónde colocar modelos
Coloca los modelos en `ComfyUI/models/…` según el tipo. Puedes definir rutas adicionales en `extra_model_paths.yaml` (usa `extra_model_paths.yaml.example` como plantilla si no existe).

## Actualizar ComfyUI
- Linux/macOS (script mejorado que clona si falta, actualiza y lanza en background con el frontend más reciente):
```bash
# Variables opcionales: COMFY_DIR, VENV_PATH, PORT
bash update_comfy.sh
```
- Manualmente con Git:
```bash
git pull
pip install -r requirements.txt
```

## Solución de problemas
- Error de CUDA al instalar PyTorch: usa la variante CPU o instala la rueda de CUDA que corresponda a tu sistema.
- No abre en el navegador: verifica que se lanzó con `--listen` y el puerto correcto, y usa el proxy `…/proxy/8188/` si estás en Jupyter.
- Permisos en PowerShell: puede que necesites `Set-ExecutionPolicy -Scope Process RemoteSigned` para activar el entorno virtual.

## Comandos rápidos (resumen)
```bash
cd /workspace/ComfyUI
python3 -m venv .venv && source .venv/bin/activate
python -m pip install --upgrade pip
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121
# CPU: pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu
pip install -r requirements.txt
nohup python main.py --listen --port 8188 > comfy.log 2>&1 &
# Abre: /proxy/8188/
```

---
Si necesitas que este README se adapte a tu plataforma exacta o que automatice todo con un script, indícalo y lo añadimos.
