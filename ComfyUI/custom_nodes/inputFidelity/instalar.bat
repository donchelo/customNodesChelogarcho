@echo off
echo ========================================
echo   Instalador OpenAI Image Fidelity
echo ========================================
echo.

echo 🔍 Verificando Python...
python --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Python no encontrado. Instala Python 3.8+ primero.
    pause
    exit /b 1
)

echo ✅ Python encontrado
echo.

echo 📦 Instalando dependencias...
pip install openai pillow torch numpy
if errorlevel 1 (
    echo ❌ Error instalando dependencias
    pause
    exit /b 1
)

echo ✅ Dependencias instaladas
echo.

echo 🔧 Verificando configuración...
if not exist "config.env" (
    echo ⚠️  Archivo config.env no encontrado
    echo 📝 Creando archivo de configuración...
    echo # Configuración para OpenAI Image Fidelity Fashion > config.env
    echo # Copia este archivo y configura tu clave API >> config.env
    echo. >> config.env
    echo # Clave API de OpenAI (obtén una en https://platform.openai.com/api-keys) >> config.env
    echo OPENAI_API_KEY=tu_clave_api_aqui >> config.env
    echo. >> config.env
    echo # Configuración por defecto >> config.env
    echo DEFAULT_INPUT_FIDELITY=high >> config.env
    echo DEFAULT_QUALITY=high >> config.env
    echo DEFAULT_SIZE=auto >> config.env
    echo DEFAULT_OUTPUT_FORMAT=png >> config.env
    echo DEFAULT_BACKGROUND=auto >> config.env
    echo ✅ Archivo config.env creado
) else (
    echo ✅ Archivo config.env encontrado
)

echo.
echo ========================================
echo   ✅ Instalación completada
echo ========================================
echo.
echo 📋 Próximos pasos:
echo 1. Edita config.env y agrega tu API key de OpenAI
echo 2. Reinicia ComfyUI
echo 3. Busca "OpenAI Image Fidelity (Fashion)" en los nodos
echo.
echo 🆘 Si tienes problemas, revisa INSTALACION_RAPIDA.md
echo.
pause