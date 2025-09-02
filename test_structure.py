#!/usr/bin/env python3
"""
Test Script para Verificar Estructura del Paquete
Desarrollado por: chelogarcho
"""

import os
import sys
import importlib

def test_package_structure():
    """Prueba la estructura del paquete de nodos"""
    print("🔍 Probando estructura del paquete...")
    
    # Verificar archivos existentes
    required_files = [
        "__init__.py",
        "nodes/CL_ImageFidelity.py",
        "nodes/CL_VirtualTryOn.py",
        "nodes/CL_GeminiFlash.py",
        "nodes/CL_OpenAIChat.py"
    ]
    
    for file_path in required_files:
        if os.path.exists(file_path):
            print(f"✅ {file_path}: Encontrado")
        else:
            print(f"❌ {file_path}: No encontrado")
            return False
    
    return True

def test_imports():
    """Prueba las importaciones del paquete"""
    print("\n🔍 Probando importaciones...")
    
    try:
        # Agregar el directorio actual al path
        sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
        
        # Importar el paquete principal
        import customNodesChelogarcho
        print("✅ Paquete principal importado exitosamente")
        
        # Verificar que las variables necesarias estén disponibles
        if hasattr(customNodesChelogarcho, 'NODE_CLASS_MAPPINGS'):
            print("✅ NODE_CLASS_MAPPINGS encontrado")
            print(f"   Nodos registrados: {list(customNodesChelogarcho.NODE_CLASS_MAPPINGS.keys())}")
        else:
            print("❌ NODE_CLASS_MAPPINGS no encontrado")
            return False
        
        if hasattr(customNodesChelogarcho, 'NODE_DISPLAY_NAME_MAPPINGS'):
            print("✅ NODE_DISPLAY_NAME_MAPPINGS encontrado")
        else:
            print("❌ NODE_DISPLAY_NAME_MAPPINGS no encontrado")
            return False
        
        return True
        
    except Exception as e:
        print(f"❌ Error durante la importación: {e}")
        import traceback
        traceback.print_exc()
        return False

def test_node_classes():
    """Prueba que las clases de nodos se puedan instanciar"""
    print("\n🔍 Probando clases de nodos...")
    
    try:
        # Importar el paquete
        import customNodesChelogarcho
        
        # Probar cada nodo
        for node_name, node_class in customNodesChelogarcho.NODE_CLASS_MAPPINGS.items():
            try:
                # Crear instancia
                instance = node_class()
                print(f"✅ {node_name}: Instanciado correctamente")
                
                # Verificar que tenga INPUT_TYPES
                if hasattr(instance, 'INPUT_TYPES'):
                    print(f"   ✅ {node_name}: INPUT_TYPES disponible")
                else:
                    print(f"   ❌ {node_name}: INPUT_TYPES no disponible")
                
                # Verificar que tenga RETURN_TYPES
                if hasattr(instance, 'RETURN_TYPES'):
                    print(f"   ✅ {node_name}: RETURN_TYPES disponible")
                else:
                    print(f"   ❌ {node_name}: RETURN_TYPES no disponible")
                
            except Exception as e:
                print(f"❌ {node_name}: Error al instanciar - {e}")
                return False
        
        return True
        
    except Exception as e:
        print(f"❌ Error probando clases de nodos: {e}")
        return False

def main():
    """Función principal de pruebas"""
    print("🚀 ComfyUI Custom Nodes - Test de Estructura")
    print("👨‍💻 Desarrollado por: chelogarcho")
    print("==================================================")
    
    # Ejecutar todas las pruebas
    tests = [
        ("Estructura del paquete", test_package_structure),
        ("Importaciones", test_imports),
        ("Clases de nodos", test_node_classes)
    ]
    
    all_passed = True
    for test_name, test_func in tests:
        print(f"\n🧪 Ejecutando: {test_name}")
        if not test_func():
            all_passed = False
            print(f"❌ {test_name}: FALLÓ")
        else:
            print(f"✅ {test_name}: PASÓ")
    
    # Resultado final
    print("\n==================================================")
    if all_passed:
        print("🎉 ¡Todas las pruebas pasaron!")
        print("✅ El paquete está listo para usar en ComfyUI")
        print("🌐 Busca nodos por 'chelogarcho' en ComfyUI")
    else:
        print("❌ Algunas pruebas fallaron")
        print("🔍 Revisa los errores anteriores")
    
    return all_passed

if __name__ == "__main__":
    success = main()
    sys.exit(0 if success else 1)
