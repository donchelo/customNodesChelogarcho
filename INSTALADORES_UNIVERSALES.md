# 🌍 Instaladores Universales - ComfyUI Custom Nodes

**Desarrollado por: chelogarcho**

## 🎯 **¿Qué son los Instaladores Universales?**

Los instaladores universales son scripts que pueden **ejecutarse desde cualquier ubicación** en tu sistema y automáticamente:

1. **🔍 Encuentran ComfyUI** en tu sistema
2. **📦 Instalan dependencias** automáticamente
3. **📁 Copian los nodos** a la ubicación correcta
4. **✅ Verifican la instalación**

## 🚀 **Ventajas de los Instaladores Universales**

- ✅ **Ejecutar desde cualquier lugar** - No importa dónde estés en la terminal
- ✅ **Detección automática** - Encuentra ComfyUI sin configuración manual
- ✅ **Instalación inteligente** - Detecta la estructura de tu sistema
- ✅ **Multiplataforma** - Funciona en Linux, Mac y Windows
- ✅ **Verificación automática** - Confirma que todo se instaló correctamente

## 📋 **Archivos Disponibles**

### **Linux/Mac:**
- `install_anywhere.sh` - Script bash universal

### **Windows:**
- `install_anywhere.bat` - Script batch universal

## 🔧 **Cómo Usar los Instaladores Universales**

### **1. Linux/Mac (Desde cualquier ubicación):**

```bash
# Opción 1: Ejecutar directamente
bash /ruta/completa/a/customNodesChelogarcho/install_anywhere.sh

# Opción 2: Dar permisos y ejecutar
chmod +x /ruta/completa/a/customNodesChelogarcho/install_anywhere.sh
/ruta/completa/a/customNodesChelogarcho/install_anywhere.sh

# Opción 3: Desde el directorio del proyecto
cd /ruta/a/customNodesChelogarcho
./install_anywhere.sh
```

### **2. Windows (Desde cualquier ubicación):**

```cmd
# Opción 1: Ejecutar directamente
"C:\ruta\completa\a\customNodesChelogarcho\install_anywhere.bat"

# Opción 2: Desde el directorio del proyecto
cd C:\ruta\a\customNodesChelogarcho
install_anywhere.bat

# Opción 3: Doble clic en el archivo
# Navegar al archivo y hacer doble clic
```

## 🌐 **Ubicaciones donde Busca ComfyUI**

### **Linux/Mac:**
- `/workspace/ComfyUI`
- `/workspace`
- `/home`
- `/root`
- Directorio actual y padres
- Búsqueda automática en `/workspace`

### **Windows:**
- `C:\workspace\ComfyUI`
- `D:\workspace\ComfyUI`
- `C:\ComfyUI`
- `D:\ComfyUI`
- Directorio actual y padres

## 📊 **Proceso de Instalación**

### **Paso 1: Búsqueda Automática**
```
🔍 Buscando ComfyUI en el sistema...
✅ ComfyUI encontrado en: /workspace/ComfyUI
```

### **Paso 2: Detección del Proyecto**
```
✅ Proyecto encontrado en: /workspace/ComfyUI/custom_nodes/customNodesChelogarcho
```

### **Paso 3: Instalación de Dependencias**
```
📦 Instalando dependencias...
✅ Dependencias instaladas
```

### **Paso 4: Copia de Archivos**
```
📁 Copiando archivos únicos...
✅ CL_ImageFidelity.py copiado exitosamente
✅ CL_VirtualTryOn.py copiado exitosamente
✅ CL_GeminiFlash.py copiado exitosamente
✅ CL_OpenAIChat.py copiado exitosamente
```

### **Paso 5: Verificación**
```
📊 RESUMEN DE INSTALACIÓN
 Archivos copiados: 4/4
 Ubicación destino: /workspace/ComfyUI/custom_nodes/

🎉 ¡INSTALACIÓN COMPLETADA EXITOSAMENTE!
```

## 🎯 **Casos de Uso Ideales**

### **1. Instalación Inicial:**
```bash
# Desde cualquier terminal
bash /ruta/a/customNodesChelogarcho/install_anywhere.sh
```

### **2. Actualización:**
```bash
# Después de git pull
git pull origin main
bash /ruta/a/customNodesChelogarcho/install_anywhere.sh
```

### **3. Reinstalación:**
```bash
# Si hay problemas
bash /ruta/a/customNodesChelogarcho/install_anywhere.sh
```

### **4. Instalación en Otro Sistema:**
```bash
# Copiar el proyecto y ejecutar
cp -r customNodesChelogarcho /nueva/ubicacion/
cd /nueva/ubicacion/customNodesChelogarcho
./install_anywhere.sh
```

## ⚠️ **Requisitos del Sistema**

### **Linux/Mac:**
- Bash shell
- Python 3.8+
- pip
- Permisos de escritura en ComfyUI

### **Windows:**
- Windows 10/11
- Python 3.8+
- pip
- Permisos de escritura en ComfyUI

## 🔍 **Solución de Problemas**

### **Error: "No se pudo encontrar ComfyUI"**
```bash
# Verificar que ComfyUI esté instalado
ls -la /workspace/ComfyUI

# Si no existe, instalar ComfyUI primero
cd /workspace
git clone https://github.com/comfyanonymous/ComfyUI.git
```

### **Error: "No se pudo encontrar el proyecto"**
```bash
# Verificar que el proyecto esté clonado
ls -la /workspace/ComfyUI/custom_nodes/customNodesChelogarcho

# Si no existe, clonar el proyecto
cd /workspace/ComfyUI/custom_nodes
git clone https://github.com/donchelo/customNodesChelogarcho.git
```

### **Error: "Permission denied"**
```bash
# Dar permisos de ejecución
chmod +x install_anywhere.sh

# O ejecutar con bash
bash install_anywhere.sh
```

## 🎉 **Beneficios Finales**

Con los instaladores universales:

1. **🚀 Instalación en un comando** desde cualquier lugar
2. **🔍 Detección automática** de ComfyUI
3. **📦 Gestión automática** de dependencias
4. **✅ Verificación completa** de la instalación
5. **🌍 Compatibilidad multiplataforma**

## 📞 **Soporte**

Para problemas con los instaladores universales:
- Revisa los mensajes de error
- Verifica que ComfyUI esté instalado
- Asegúrate de tener permisos de escritura
- Contacta al desarrollador: chelogarcho

---

**¡Los instaladores universales hacen que la instalación sea súper fácil desde cualquier lugar! 🚀✨**
