@echo off
setlocal enabledelayedexpansion

echo ========================================
echo ComfyUI Custom Nodes - Instalador Universal
echo Desarrollado por: chelogarcho
echo ========================================
echo.

echo Buscando ComfyUI en el sistema...

:: Buscar ComfyUI en ubicaciones comunes
set "COMFYUI_DIR="

if exist "C:\workspace\ComfyUI" (
    set "COMFYUI_DIR=C:\workspace\ComfyUI"
    goto :found_comfyui
)

if exist "D:\workspace\ComfyUI" (
    set "COMFYUI_DIR=D:\workspace\ComfyUI"
    goto :found_comfyui
)

if exist "C:\ComfyUI" (
    set "COMFYUI_DIR=C:\ComfyUI"
    goto :found_comfyui
)

if exist "D:\ComfyUI" (
    set "COMFYUI_DIR=D:\ComfyUI"
    goto :found_comfyui
)

:: Buscar en directorio actual y padres
if exist "ComfyUI\main.py" (
    set "COMFYUI_DIR=%CD%\ComfyUI"
    goto :found_comfyui
)

if exist "..\ComfyUI\main.py" (
    set "COMFYUI_DIR=%CD%\..\ComfyUI"
    goto :found_comfyui
)

if exist "..\..\ComfyUI\main.py" (
    set "COMFYUI_DIR=%CD%\..\..\ComfyUI"
    goto :found_comfyui
)

echo ERROR: No se pudo encontrar ComfyUI
echo Asegurate de que ComfyUI este instalado
pause
exit /b 1

:found_comfyui
echo ComfyUI encontrado en: !COMFYUI_DIR!

:: Verificar que sea realmente ComfyUI
if not exist "!COMFYUI_DIR!\custom_nodes" (
    echo ERROR: El directorio encontrado no parece ser ComfyUI valido
    pause
    exit /b 1
)

echo.
echo Instalando dependencias...

:: Encontrar el directorio del proyecto
set "PROJECT_DIR="

if exist "install_jupyter.bat" (
    set "PROJECT_DIR=%CD%"
    goto :found_project
)

if exist "customNodesChelogarcho\install_jupyter.bat" (
    set "PROJECT_DIR=%CD%\customNodesChelogarcho"
    goto :found_project
)

:: Buscar el proyecto
for /d /r "C:\workspace" %%i in (customNodesChelogarcho) do (
    if exist "%%i\install_jupyter.bat" (
        set "PROJECT_DIR=%%i"
        goto :found_project
    )
)

for /d /r "D:\workspace" %%i in (customNodesChelogarcho) do (
    if exist "%%i\install_jupyter.bat" (
        set "PROJECT_DIR=%%i"
        goto :found_project
    )
)

echo ERROR: No se pudo encontrar el proyecto customNodesChelogarcho
pause
exit /b 1

:found_project
echo Proyecto encontrado en: !PROJECT_DIR!

:: Instalar dependencias
if exist "!PROJECT_DIR!\requirements_all_nodes.txt" (
    echo Instalando dependencias...
    pip install --upgrade pip setuptools wheel
    pip install -r "!PROJECT_DIR!\requirements_all_nodes.txt"
    echo Dependencias instaladas
)

echo.
echo Copiando archivos unicos...

:: Lista de archivos a copiar
set "SINGLE_FILES=CL_ImageFidelity.py CL_VirtualTryOn.py CL_GeminiFlash.py CL_OpenAIChat.py"
set "SUCCESS_COUNT=0"

:: Copiar archivos
for %%f in (%SINGLE_FILES%) do (
    if exist "!PROJECT_DIR!\nodes\%%f" (
        copy "!PROJECT_DIR!\nodes\%%f" "!COMFYUI_DIR!\custom_nodes\" >nul
        if !errorlevel! equ 0 (
            echo [OK] %%f copiado exitosamente
            set /a SUCCESS_COUNT+=1
        ) else (
            echo [ERROR] Error copiando %%f
        )
    ) else (
        echo [ERROR] %%f no encontrado en !PROJECT_DIR!\nodes\
    )
)

echo.
echo ========================================
echo RESUMEN DE INSTALACION
echo ========================================
echo Archivos copiados: !SUCCESS_COUNT!/4
echo Ubicacion destino: !COMFYUI_DIR!\custom_nodes\

if !SUCCESS_COUNT! equ 4 (
    echo.
    echo [SUCCESS] INSTALACION COMPLETADA EXITOSAMENTE!
    echo.
    echo ComfyUI esta listo para usar!
    echo Reinicia ComfyUI para que los cambios surtan efecto
    echo Busca nodos por 'CL_' o 'chelogarcho' en ComfyUI
    echo.
    echo IMPORTANTE - API Keys Visibles:
    echo    - Todos los nodos tienen campos 'api_key' visibles
    echo    - No mas archivos de configuracion necesarios
    echo.
    echo Nodos instalados:
    for %%f in (%SINGLE_FILES%) do (
        echo    [OK] %%f
    )
) else (
    echo.
    echo [WARNING] Algunos archivos no se copiaron correctamente
    echo Revisa los errores anteriores
)

echo.
echo ========================================
echo Desarrollado por: chelogarcho
echo ========================================
echo.
pause
