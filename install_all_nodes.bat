@echo off
REM ComfyUI Custom Nodes - Instalador Automático para Windows
REM Desarrollado por: chelogarcho
REM Script para instalar todos los custom nodes automáticamente

echo 🚀 ComfyUI Custom Nodes - Instalador Automático para Windows
echo 👨‍💻 Desarrollado por: chelogarcho
echo ==================================================

REM Verificar que estamos en el directorio correcto
if not exist "custom_nodes" (
    echo ❌ Error: No se encontró el directorio 'custom_nodes'
    echo Ejecuta este script desde la raíz de ComfyUI
    pause
    exit /b 1
)

REM Verificar Python
python --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Error: Python no está instalado o no está en el PATH
    echo Por favor instala Python 3.8+ y asegúrate de que esté en el PATH
    pause
    exit /b 1
)

REM Verificar pip
pip --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Error: pip no está instalado o no está en el PATH
    echo Por favor instala pip y asegúrate de que esté en el PATH
    pause
    exit /b 1
)

echo ✅ Python y pip están disponibles

REM Función para instalar dependencias de un nodo
:install_node_dependencies
set node_name=%~1
if exist "custom_nodes\%node_name%\requirements.txt" (
    echo [INFO] Instalando dependencias para %node_name%...
    pip install -r "custom_nodes\%node_name%\requirements.txt" --quiet
    if errorlevel 1 (
        echo ⚠️ Warning: Error instalando dependencias de %node_name%, continuando...
    ) else (
        echo ✅ Dependencias de %node_name% instaladas correctamente
    )
) else (
    echo ⚠️ Warning: No se encontró requirements.txt para %node_name%
)
goto :eof

REM Función para verificar instalación de un nodo
:verify_node_installation
set node_name=%~1
if exist "custom_nodes\%node_name%\__init__.py" (
    echo ✅ %node_name% está listo
    exit /b 0
) else (
    echo ❌ %node_name% no se instaló correctamente
    exit /b 1
)

REM Instalar dependencias del sistema
echo [INFO] Instalando dependencias del sistema...
pip install --upgrade pip setuptools wheel

REM Instalar dependencias de cada nodo
echo [INFO] Instalando dependencias de todos los nodos...
call :install_node_dependencies inputFidelity
call :install_node_dependencies mirrorNode
call :install_node_dependencies bananaNode
call :install_node_dependencies openai_simple_chat

REM Verificar instalación
echo [INFO] Verificando instalación de nodos...
set INSTALLATION_SUCCESS=true

call :verify_node_installation inputFidelity
if errorlevel 1 set INSTALLATION_SUCCESS=false

call :verify_node_installation mirrorNode
if errorlevel 1 set INSTALLATION_SUCCESS=false

call :verify_node_installation bananaNode
if errorlevel 1 set INSTALLATION_SUCCESS=false

call :verify_node_installation openai_simple_chat
if errorlevel 1 set INSTALLATION_SUCCESS=false

echo.
echo ==================================================
if "%INSTALLATION_SUCCESS%"=="true" (
    echo 🎉 ¡Todos los custom nodes se instalaron correctamente!
    echo.
    echo 📋 Nodos instalados:
    echo    ✅ inputFidelity
    echo    ✅ mirrorNode
    echo    ✅ bananaNode
    echo    ✅ openai_simple_chat
    echo.
    echo 🚀 ComfyUI está listo para usar con tus custom nodes!
    echo 💡 Reinicia ComfyUI para que los cambios surtan efecto
) else (
    echo ❌ Algunos nodos no se instalaron correctamente
    echo 🔍 Revisa los logs anteriores para más detalles
    pause
    exit /b 1
)

echo.
echo 📚 Recursos adicionales:
echo    - README_CUSTOM_NODES.md: Documentación de cada nodo
echo    - workflows_examples/: Ejemplos de uso
echo    - custom_nodes\*\README.md: Documentación específica de cada nodo
echo.
echo 👨‍💻 Desarrollado por: chelogarcho
echo ==================================================
echo.
pause
