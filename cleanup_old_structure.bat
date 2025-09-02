@echo off
echo ========================================
echo LIMPIEZA DE ESTRUCTURA ANTIGUA
echo ========================================
echo.
echo Este script eliminara la estructura antigua de nodos
echo y dejara solo los archivos unicos nuevos.
echo.

set /p confirm="¿Continuar? (s/n): "
if /i not "%confirm%"=="s" goto :end

echo.
echo Eliminando directorios antiguos...

if exist "custom_nodes\inputFidelity" (
    echo - Eliminando inputFidelity...
    rmdir /s /q "custom_nodes\inputFidelity"
)

if exist "custom_nodes\mirrorNode" (
    echo - Eliminando mirrorNode...
    rmdir /s /q "custom_nodes\mirrorNode"
)

if exist "custom_nodes\bananaNode" (
    echo - Eliminando bananaNode...
    rmdir /s /q "custom_nodes\bananaNode"
)

if exist "custom_nodes\openai_simple_chat" (
    echo - Eliminando openai_simple_chat...
    rmdir /s /q "custom_nodes\openai_simple_chat"
)

echo.
echo Limpieza completada!
echo.
echo Estructura nueva mantenida:
echo - nodes\CL_ImageFidelity.py
echo - nodes\CL_VirtualTryOn.py
echo - nodes\CL_GeminiFlash.py
echo - nodes\CL_OpenAIChat.py
echo.
echo Archivos de instalacion mantenidos:
echo - install_jupyter.sh
echo - install_jupyter.bat
echo - README.md
echo - requirements_all_nodes.txt
echo.

:end
pause
