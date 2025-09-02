#!/usr/bin/env python3
"""
ComfyUI Custom Nodes - Test Script
Desarrollado por: chelogarcho
Script para verificar que todos los custom nodes estén funcionando correctamente
"""

import os
import sys
import importlib
import traceback

def test_node_import(node_name, module_path):
    """Prueba la importación de un nodo específico"""
    try:
        print(f"🔍 Probando {node_name}...")
        
        # Verificar que el directorio existe
        if not os.path.exists(module_path):
            print(f"❌ {node_name}: Directorio no encontrado en {module_path}")
            return False
        
        # Verificar archivo __init__.py
        init_file = os.path.join(module_path, "__init__.py")
        if not os.path.exists(init_file):
            print(f"❌ {node_name}: __init__.py no encontrado")
            return False
        
        # Verificar requirements.txt
        req_file = os.path.join(module_path, "requirements.txt")
        if not os.path.exists(req_file):
            print(f"⚠️ {node_name}: requirements.txt no encontrado")
        
        # Intentar importar el módulo
        sys.path.insert(0, os.path.dirname(module_path))
        module = importlib.import_module(os.path.basename(module_path))
        
        # Verificar que tenga las variables necesarias
        if hasattr(module, 'NODE_CLASS_MAPPINGS'):
            print(f"✅ {node_name}: NODE_CLASS_MAPPINGS encontrado")
        else:
            print(f"❌ {node_name}: NODE_CLASS_MAPPINGS no encontrado")
            return False
        
        if hasattr(module, 'NODE_DISPLAY_NAME_MAPPINGS'):
            print(f"✅ {node_name}: NODE_DISPLAY_NAME_MAPPINGS encontrado")
        else:
            print(f"❌ {node_name}: NODE_DISPLAY_NAME_MAPPINGS no encontrado")
            return False
        
        print(f"✅ {node_name}: Importación exitosa")
        return True
        
    except Exception as e:
        print(f"❌ {node_name}: Error durante la importación: {e}")
        print(f"   Traceback: {traceback.format_exc()}")
        return False

def test_dependencies():
    """Prueba las dependencias principales"""
    print("🔍 Probando dependencias principales...")
    
    dependencies = [
        'torch',
        'numpy',
        'PIL',
        'openai',
        'requests'
    ]
    
    success = True
    for dep in dependencies:
        try:
            importlib.import_module(dep)
            print(f"✅ {dep}: Disponible")
        except ImportError:
            print(f"❌ {dep}: No disponible")
            success = False
    
    return success

def test_config_files():
    """Prueba la existencia de archivos de configuración"""
    print("🔍 Probando archivos de configuración...")
    
    config_files = [
        'config.env.example',
        'requirements_all_nodes.txt',
        'install_jupyter.sh'
    ]
    
    success = True
    for config_file in config_files:
        if os.path.exists(config_file):
            print(f"✅ {config_file}: Encontrado")
        else:
            print(f"❌ {config_file}: No encontrado")
            success = False
    
    return success

def main():
    """Función principal de pruebas"""
    print("🚀 ComfyUI Custom Nodes - Test Script")
    print("👨‍💻 Desarrollado por: chelogarcho")
    print("🔍 Busca 'chelogarcho' para encontrar todos los custom nodes")
    print("=" * 50)
    
    # Verificar que estamos en el directorio correcto
    if not os.path.exists("custom_nodes"):
        print("❌ Error: No se encontró el directorio 'custom_nodes'")
        print("   Ejecuta este script desde la raíz de ComfyUI")
        return False
    
    # Lista de nodos a probar
    nodes_to_test = [
        ("inputFidelity", "custom_nodes/inputFidelity"),
        ("mirrorNode", "custom_nodes/mirrorNode"),
        ("bananaNode", "custom_nodes/bananaNode"),
        ("openai_simple_chat", "custom_nodes/openai_simple_chat")
    ]
    
    print(f"\n📋 Probando {len(nodes_to_test)} custom nodes...")
    
    # Probar cada nodo
    node_results = []
    for node_name, module_path in nodes_to_test:
        result = test_node_import(node_name, module_path)
        node_results.append((node_name, result))
        print()
    
    # Probar dependencias
    print("=" * 50)
    deps_success = test_dependencies()
    
    # Probar archivos de configuración
    print("\n" + "=" * 50)
    config_success = test_config_files()
    
    # Resumen de resultados
    print("\n" + "=" * 50)
    print("📊 RESUMEN DE PRUEBAS")
    print("=" * 50)
    
    # Resultados de nodos
    successful_nodes = sum(1 for _, result in node_results if result)
    total_nodes = len(node_results)
    
    print(f"🎯 Custom Nodes: {successful_nodes}/{total_nodes} exitosos")
    for node_name, result in node_results:
        status = "✅" if result else "❌"
        print(f"   {status} {node_name}")
    
    # Resultados de dependencias
    deps_status = "✅" if deps_success else "❌"
    print(f"\n📦 Dependencias: {deps_status}")
    
    # Resultados de configuración
    config_status = "✅" if config_success else "❌"
    print(f"⚙️ Archivos de Configuración: {config_status}")
    
    # Resultado general
    overall_success = all(result for _, result in node_results) and deps_success and config_success
    
    print("\n" + "=" * 50)
    if overall_success:
        print("🎉 ¡Todas las pruebas pasaron exitosamente!")
        print("🚀 ComfyUI está listo para usar con tus custom nodes")
    else:
        print("❌ Algunas pruebas fallaron")
        print("🔍 Revisa los errores anteriores para más detalles")
    
    print("=" * 50)
    
    return overall_success

if __name__ == "__main__":
    try:
        success = main()
        sys.exit(0 if success else 1)
    except KeyboardInterrupt:
        print("\n\n⚠️ Pruebas interrumpidas por el usuario")
        sys.exit(1)
    except Exception as e:
        print(f"\n\n❌ Error inesperado: {e}")
        traceback.print_exc()
        sys.exit(1)
