"""
CL_OpenAIChat - OpenAI Simple Chat Node
Developer: chelogarcho
Allows integration of OpenAI chat directly in ComfyUI with image analysis capabilities

This is a single-file ComfyUI node that consolidates all functionality.
Dependencies: openai>=1.0.0, requests>=2.25.0, pillow>=9.0.0, torch>=1.9.0, numpy>=1.21.0, langdetect>=1.0.9

Installation: Copy this file to ComfyUI/custom_nodes/
Usage: Search for "CL_OpenAIChat" or "chelogarcho" in ComfyUI
"""

import os
import json
import base64
import io
import requests
from typing import Dict, Any, Optional, List
import torch
import numpy as np
from PIL import Image

# Lazy-imports para que el nodo sea visible aunque falten dependencias
try:
    import openai  # type: ignore
    from openai import OpenAI  # type: ignore
    _HAS_OPENAI = True
except Exception:
    openai = None  # type: ignore
    OpenAI = None  # type: ignore
    _HAS_OPENAI = False

try:
    from langdetect import detect, LangDetectException  # type: ignore
    _HAS_LANGDETECT = True
except Exception:
    detect = None  # type: ignore
    LangDetectException = Exception  # type: ignore
    _HAS_LANGDETECT = False


class CL_OpenAIChat:
    """
    Nodo para chat con OpenAI usando Chat Completions API
    Procesa texto + imágenes y devuelve respuestas mejoradas en inglés
    
    Developer: chelogarcho
    """
    
    def __init__(self):
        self.client = None
        self.api_key = None
    
    def initialize_client(self, api_key):
        """Inicializa el cliente de OpenAI con API key del nodo"""
        if not api_key or api_key.strip() == "":
            raise ValueError("OpenAI API Key is required. Please enter your API key in the node.")
        
        try:
            if not _HAS_OPENAI:
                raise ImportError("openai no está instalado. Instala con: pip install openai>=1.0.0")
            self.client = OpenAI(api_key=api_key.strip())  # type: ignore
            return True
        except Exception as e:
            raise ValueError(f"Error inicializando cliente OpenAI: {e}")
        
    @classmethod
    def INPUT_TYPES(cls):
        return {
            "required": {
                "api_key": ("STRING", {
                    "multiline": False,
                    "default": "",
                    "placeholder": "Enter your OpenAI API key here"
                }),
                "user_prompt": ("STRING", {"default": "Enhance this image", "multiline": True}),
                "model": (["gpt-4o-mini", "gpt-4o", "gpt-4-turbo", "gpt-4"], {"default": "gpt-4o-mini"}),
                "max_characters": ("INT", {"default": 500, "min": 50, "max": 2000}),
                "system_prompt": ("STRING", {"default": "You are a helpful assistant that always responds in English. Enhance and improve the user's request with professional terminology.", "multiline": True}),
            },
            "optional": {
                "image_1": ("IMAGE",),
                "image_2": ("IMAGE",),
                "image_3": ("IMAGE",),
            }
        }
    
    RETURN_TYPES = ("STRING",)
    RETURN_NAMES = ("response_text",)
    FUNCTION = "process_with_vision"
    CATEGORY = "chelogarcho/AI Chat"
    
    def image_to_base64(self, image_tensor) -> str:
        """
        Convierte tensor de imagen de ComfyUI a base64 para OpenAI API
        """
        try:
            # Convertir tensor a numpy array
            if isinstance(image_tensor, torch.Tensor):
                image_array = image_tensor.cpu().numpy()
            else:
                image_array = image_tensor
            
            # Normalizar valores de 0-1 a 0-255
            if image_array.max() <= 1.0:
                image_array = (image_array * 255).astype(np.uint8)
            
            # Asegurar formato correcto (H, W, C)
            if len(image_array.shape) == 4:
                image_array = image_array[0]  # Remove batch dimension
            
            if len(image_array.shape) == 3 and image_array.shape[0] in [1, 3, 4]:
                image_array = np.transpose(image_array, (1, 2, 0))
            
            # Convertir a PIL Image
            if image_array.shape[2] == 1:  # Grayscale
                image = Image.fromarray(image_array[:, :, 0], mode='L').convert('RGB')
            elif image_array.shape[2] == 3:  # RGB
                image = Image.fromarray(image_array, mode='RGB')
            elif image_array.shape[2] == 4:  # RGBA
                image = Image.fromarray(image_array, mode='RGBA').convert('RGB')
            else:
                raise ValueError(f"Formato de imagen no soportado: {image_array.shape}")
            
            # Convertir a base64
            buffer = io.BytesIO()
            image.save(buffer, format='PNG')
            img_str = base64.b64encode(buffer.getvalue()).decode()
            
            return img_str
            
        except Exception as e:
            print(f"Error convirtiendo imagen a base64: {str(e)}")
            return ""
    
    def detect_language(self, text: str) -> str:
        """
        Detecta el idioma del texto de entrada
        """
        try:
            if not _HAS_LANGDETECT:
                return "en"
            if not text or len(text.strip()) < 3:
                return "en"  # Default a inglés si texto muy corto
            
            detected = detect(text)
            return detected
        except LangDetectException:
            return "en"  # Default a inglés si no se puede detectar
        except Exception:
            return "en"
    
    def process_with_vision(self, api_key: str, user_prompt: str, model: str, max_characters: int, 
                           system_prompt: str, image_1=None, image_2=None, 
                           image_3=None) -> tuple:
        """
        Procesa texto + imágenes con OpenAI Chat Completions API
        Devuelve respuesta mejorada siempre en inglés
        """
        try:
            # Inicializar cliente OpenAI con la API key del nodo
            if not self.initialize_client(api_key):
                return ("Error: No se pudo inicializar el cliente OpenAI con la API key.",)
            
            # Detectar idioma del prompt del usuario
            detected_lang = self.detect_language(user_prompt)
            print(f"Idioma detectado: {detected_lang}")
            
            # Preparar contenido con imágenes
            content = []
            
            # Agregar texto del sistema
            content.append({
                "type": "text",
                "text": f"{system_prompt}\n\nUser request (detected language: {detected_lang}): {user_prompt}\n\nPlease respond in English with a maximum of {max_characters} characters."
            })
            
            # Agregar imágenes si están disponibles
            images = [img for img in [image_1, image_2, image_3] if img is not None]
            
            for i, image in enumerate(images):
                try:
                    base64_image = self.image_to_base64(image)
                    if base64_image:
                        content.append({
                            "type": "image_url",
                            "image_url": {
                                "url": f"data:image/png;base64,{base64_image}"
                            }
                        })
                        print(f"Imagen {i+1} agregada correctamente")
                except Exception as e:
                    print(f"Error procesando imagen {i+1}: {str(e)}")
            
            # Realizar llamada a OpenAI Chat Completions API
            response = self.client.chat.completions.create(
                model=model,
                messages=[
                    {
                        "role": "user",
                        "content": content
                    }
                ],
                max_tokens=max_characters * 2,  # Aproximadamente 2 tokens por carácter
                temperature=0.7
            )
            
            # Extraer respuesta
            ai_response = response.choices[0].message.content.strip()
            
            # Asegurar que la respuesta esté en inglés y respete el límite de caracteres
            if len(ai_response) > max_characters:
                ai_response = ai_response[:max_characters].rsplit(' ', 1)[0] + "..."
            
            # Verificar que la respuesta esté en inglés (detección básica)
            response_lang = self.detect_language(ai_response)
            if response_lang != "en":
                print(f"Advertencia: Respuesta detectada en {response_lang}, forzando inglés")
                # Si no está en inglés, agregar instrucción adicional
                ai_response = f"English response: {ai_response}"
                if len(ai_response) > max_characters:
                    ai_response = ai_response[:max_characters].rsplit(' ', 1)[0] + "..."
            
            # Información de uso
            usage_info = f"Tokens: {response.usage.total_tokens} | Caracteres: {len(ai_response)}/{max_characters}"
            print(f"Procesamiento exitoso - {usage_info}")
            
            return (ai_response,)
            
        except openai.AuthenticationError:
            return ("Error: Clave API inválida",)
        except openai.RateLimitError:
            return ("Error: Límite de tasa excedido",)
        except openai.APIError as e:
            return (f"Error de API: {str(e)}",)
        except Exception as e:
            return (f"Error inesperado: {str(e)}",)


# Node registration for ComfyUI
NODE_CLASS_MAPPINGS = {
    "CL_OpenAIChat": CL_OpenAIChat,
}

NODE_DISPLAY_NAME_MAPPINGS = {
    "CL_OpenAIChat": "CL OpenAI Chat (by chelogarcho)",
}

# Export for ComfyUI
__all__ = ['NODE_CLASS_MAPPINGS', 'NODE_DISPLAY_NAME_MAPPINGS']

# Dependency information (for documentation)
DEPENDENCIES = [
    "openai>=1.0.0",
    "requests>=2.25.0",
    "pillow>=9.0.0",
    "torch>=1.9.0",
    "numpy>=1.21.0",
    "langdetect>=1.0.9"
]

# Installation instructions
INSTALLATION_INSTRUCTIONS = """
Installation Instructions for CL_OpenAIChat:

1. Copy this file to: ComfyUI/custom_nodes/CL_OpenAIChat.py

2. Install dependencies:
   pip install openai>=1.0.0 requests>=2.25.0 pillow>=9.0.0 torch>=1.9.0 numpy>=1.21.0 langdetect>=1.0.9

3. Restart ComfyUI

4. Search for "CL_OpenAIChat" or "chelogarcho" in ComfyUI

5. Get your OpenAI API key from: https://platform.openai.com/api-keys

6. Paste your API key in the "api_key" field of the node

Usage:
- CL_OpenAIChat: Simple chat with image analysis

Features:
- Multi-language input detection (always responds in English)
- Support for up to 3 images per request
- Configurable response length
- Custom system prompts
- Multiple OpenAI models supported (gpt-4o-mini, gpt-4o, gpt-4-turbo, gpt-4)

Developer: chelogarcho
"""
