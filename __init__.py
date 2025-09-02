"""
ComfyUI Custom Nodes - by chelogarcho
Una colección completa de nodos personalizados para ComfyUI que extiende las capacidades
de generación y procesamiento de imágenes con IA.

Custom Nodes incluidos:
- CL_ImageFidelity: OpenAI Image Analysis para moda y productos
- CL_VirtualTryOn: Virtual Try-On con YourMirror.io
- CL_GeminiFlash: Generación/edición de imágenes con Google Gemini 2.5 Flash
- CL_OpenAIChat: Chat inteligente con OpenAI GPT
- CL_OpenAIConversation: Chat con conversación persistente

Developer: chelogarcho
Version: 1.0.0
"""

# Importar todos los nodos personalizados
from .nodes.CL_ImageFidelity import CL_ImageFidelity
from .nodes.CL_VirtualTryOn import CL_VirtualTryOn
from .nodes.CL_GeminiFlash import CL_GeminiFlash
from .nodes.CL_OpenAIChat import CL_OpenAIChat, CL_OpenAIConversation

# Mapeo de clases de nodos para ComfyUI
NODE_CLASS_MAPPINGS = {
    "CL_ImageFidelity": CL_ImageFidelity,
    "CL_VirtualTryOn": CL_VirtualTryOn,
    "CL_GeminiFlash": CL_GeminiFlash,
    "CL_OpenAIChat": CL_OpenAIChat,
    "CL_OpenAIConversation": CL_OpenAIConversation,
}

# Mapeo de nombres de visualización para ComfyUI
NODE_DISPLAY_NAME_MAPPINGS = {
    "CL_ImageFidelity": "CL Image Fidelity",
    "CL_VirtualTryOn": "CL Virtual Try-On",
    "CL_GeminiFlash": "CL Gemini Flash",
    "CL_OpenAIChat": "CL OpenAI Chat",
    "CL_OpenAIConversation": "CL OpenAI Conversation",
}

# Información del paquete
__version__ = "1.0.0"
__author__ = "chelogarcho"
__description__ = "ComfyUI Custom Nodes Collection for AI Image Processing"
__url__ = "https://github.com/donchelo/customNodesChelogarcho"

# Función de inicialización (opcional)
def init():
    """Función de inicialización del paquete de nodos"""
    print(f"🚀 ComfyUI Custom Nodes v{__version__} by {__author__} cargado exitosamente!")
    print(f"📋 Nodos disponibles: {', '.join(NODE_CLASS_MAPPINGS.keys())}")
    print(f"🌐 Busca nodos por 'chelogarcho' en ComfyUI")

# Llamar a la función de inicialización cuando se importe el módulo
init()
