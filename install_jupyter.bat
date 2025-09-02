@echo off
REM 🚀 ComfyUI Custom Nodes - Instalador Automático para Windows
REM Desarrollado por: chelogarcho
REM Optimizado para entornos Windows con ComfyUI

echo 🚀 ComfyUI Custom Nodes - Instalador Automático para Windows
echo 👨‍💻 Desarrollado por: chelogarcho
echo 🔑 API Keys visibles en cada nodo (no más archivos de configuración)
echo ==================================================

REM Verificar argumentos para instalación ultra-simple
if "%1"=="--ultra-simple" (
    echo ⚡ Instalación Ultra-Simple activada...
    echo 🚀 Instalando ComfyUI Custom Nodes...
    
    REM Instalación ultra-simple
    python -m pip install --upgrade pip setuptools wheel --quiet
    python -m pip install -r requirements_all_nodes.txt --quiet --no-cache-dir
    
    echo ✅ Instalación completada! Busca nodos por 'chelogarcho' en ComfyUI
    echo 🌐 Accede desde: http://localhost:8188/
    goto :end
)

REM Verificar que estamos en el directorio correcto
if not exist "custom_nodes" (
    echo ⚠️ No se encontró el directorio 'custom_nodes' en el directorio actual.
    echo 🔍 Verificando si estamos en el directorio correcto...
    
    REM Si estamos en el directorio del proyecto, cambiar a ComfyUI
    if exist "install_jupyter.bat" if exist "requirements_all_nodes.txt" (
        echo Parece que estamos en el directorio del proyecto. Buscando ComfyUI...
        
        REM Buscar ComfyUI en directorios padre
        if exist "..\ComfyUI" (
            echo Encontrado ComfyUI en directorio padre. Cambiando...
            cd ..\ComfyUI
        ) else if exist "..\..\ComfyUI" (
            echo Encontrado ComfyUI en directorio padre del padre. Cambiando...
            cd ..\..\ComfyUI
        ) else (
            echo ❌ No se pudo encontrar ComfyUI. Ejecuta este script desde la raíz de ComfyUI o desde el directorio del proyecto.
            pause
            exit /b 1
        )
    ) else (
        echo ❌ No se encontró el directorio 'custom_nodes'. Ejecuta este script desde la raíz de ComfyUI.
        pause
        exit /b 1
    )
)

REM Verificar Python
python --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Python no está instalado. Por favor instala Python 3.8+
    pause
    exit /b 1
)

REM Verificar pip
python -m pip --version >nul 2>&1
if errorlevel 1 (
    echo ❌ pip no está instalado. Por favor instala pip
    pause
    exit /b 1
)

echo [INFO] Python y pip verificados correctamente

REM Función para instalar dependencias de un nodo
:install_node_dependencies
set node_name=%1
set requirements_file=custom_nodes\%node_name%\requirements.txt

if exist "%requirements_file%" (
    echo [INFO] Instalando dependencias para %node_name%...
    python -m pip install -r "%requirements_file%" --quiet --no-cache-dir
    if errorlevel 1 (
        echo ⚠️ Error instalando dependencias de %node_name%, continuando...
    ) else (
        echo ✅ Dependencias de %node_name% instaladas
    )
) else (
    echo ⚠️ No se encontró requirements.txt para %node_name%
)
goto :eof

REM Función para verificar instalación de un nodo
:verify_node_installation
set node_name=%1
set init_file=custom_nodes\%node_name%\__init__.py
set main_file=custom_nodes\%node_name%\*.py

if exist "%init_file%" (
    dir /b "%main_file%" >nul 2>&1
    if errorlevel 1 (
        echo ❌ %node_name% no se instaló correctamente
        exit /b 1
    ) else (
        echo ✅ %node_name% está listo
        exit /b 0
    )
) else (
    echo ❌ %node_name% no se instaló correctamente
    exit /b 1
)

REM Lista de nodos a instalar
set NODES=inputFidelity mirrorNode bananaNode openai_simple_chat

REM Instalación principal
echo [STEP] 1. Actualizando dependencias del sistema...
python -m pip install --upgrade pip setuptools wheel --quiet

echo [STEP] 2. Instalando dependencias de todos los nodos...
for %%n in (%NODES%) do (
    if exist "custom_nodes\%%n" (
        call :install_node_dependencies %%n
    ) else (
        echo ⚠️ Directorio %%n no encontrado
    )
)

echo [STEP] 3. Verificando instalación de nodos...
set INSTALLATION_SUCCESS=true

for %%n in (%NODES%) do (
    call :verify_node_installation %%n
    if errorlevel 1 (
        set INSTALLATION_SUCCESS=false
    )
)

REM Información final
echo.
echo ==================================================
if "%INSTALLATION_SUCCESS%"=="true" (
    echo 🎉 ¡Todos los custom nodes se instalaron correctamente!
    echo.
    echo 📋 Nodos instalados:
    for %%n in (%NODES%) do (
        echo    ✅ %%n
    )
    echo.
    echo 🚀 ComfyUI está listo para usar con tus custom nodes!
    echo 💡 Reinicia ComfyUI para que los cambios surtan efecto
    echo.
    echo 🌐 Acceso desde Windows:
    echo    - URL: http://localhost:8188/
    echo    - Busca nodos por 'chelogarcho' en ComfyUI
    echo.
    echo 🔑 IMPORTANTE - API Keys Visibles:
    echo    - Todos los nodos tienen campos 'api_key' visibles
    echo    - No más archivos de configuración necesarios
    echo    - Pega tu API key directamente en cada nodo
    echo.
    echo ⚡ Para instalación ultra-simple en el futuro:
    echo    install_jupyter.bat --ultra-simple
) else (
    echo ❌ Algunos nodos no se instalaron correctamente
    echo 🔍 Revisa los logs anteriores para más detalles
    pause
    exit /b 1
)

echo.
echo 📚 Recursos disponibles:
echo    - README.md: Documentación completa
echo    - workflows_examples/: Ejemplos de uso
echo.
echo 🔧 Comandos útiles:
echo    - Reiniciar ComfyUI: Reinicia la aplicación
echo    - Ver nodos: Busca 'chelogarcho' en ComfyUI
echo    - Configurar API: Pega API key en campo 'api_key' del nodo
echo.
echo 👨‍💻 Desarrollado por: chelogarcho
echo ==================================================

:end
pause
