"""
CL_GeminiFlash - Google Gemini Flash Image Node
Developer: chelogarcho
Integrates Google Gemini 2.5 Flash for advanced image generation and editing

This is a single-file ComfyUI node that consolidates all functionality.
Dependencies: google-generativeai>=0.8.0, pillow>=9.0.0, torch>=1.9.0, numpy>=1.21.0

Installation: Copy this file to ComfyUI/custom_nodes/
Usage: Search for "CL_GeminiFlash" or "chelogarcho" in ComfyUI
"""

import os
import io
import base64
import torch
import numpy as np
from PIL import Image
from typing import Optional, Tuple, List, Dict, Any

# Try to import Google Generative AI, provide helpful error message if not available
try:
    import google.generativeai as genai
    from google.generativeai.types import HarmCategory, HarmBlockThreshold
except ImportError:
    raise ImportError(
        "google-generativeai package is required for CL_GeminiFlash node. "
        "Install with: pip install google-generativeai>=0.8.0"
    )


class CL_GeminiFlash:
    """
    Nodo personalizado para ComfyUI que integra Gemini 2.5 Flash Image
    Capacidades: generación, edición, consistencia de personajes, fusión multi-imagen
    
    Developer: chelogarcho
    """
    
    def __init__(self):
        self.client = None
        self.api_key = None
    
    def initialize_client(self, api_key):
        """Inicializa el cliente de Google Generative AI con API key del nodo"""
        if not api_key or api_key.strip() == "":
            raise ValueError("Google API Key is required. Please enter your API key in the node.")
        
        try:
            genai.configure(api_key=api_key.strip())
            self.client = genai.GenerativeModel('gemini-2.5-flash-image-preview')
            print("✅ Cliente Gemini Flash Image inicializado correctamente")
            return True
        except Exception as e:
            raise ValueError(f"Error inicializando cliente Gemini: {e}")
    
    @classmethod
    def INPUT_TYPES(cls):
        return {
            "required": {
                "api_key": ("STRING", {
                    "multiline": False,
                    "default": "",
                    "placeholder": "Enter your Google API key here"
                }),
                "prompt": ("STRING", {
                    "multiline": True,
                    "default": "Generate a beautiful landscape with mountains and a lake"
                }),
                "mode": ([
                    "generate",
                    "edit", 
                    "character_consistency",
                    "multi_image_fusion",
                    "prompt_based_editing",
                    "world_knowledge",
                    "custom"
                ], {"default": "generate"}),
                "model": (["gemini-2.5-flash-image-preview"], {"default": "gemini-2.5-flash-image-preview"}),
            },
            "optional": {
                "primary_image": ("IMAGE",),
                "reference_image": ("IMAGE",),
                "secondary_image": ("IMAGE",),
                "mask_image": ("IMAGE",),
            }
        }
    
    RETURN_TYPES = ("IMAGE", "STRING", "STRING")
    RETURN_NAMES = ("image", "text_response", "debug_info")
    FUNCTION = "generate_with_gemini"
    CATEGORY = "chelogarcho/AI Generation"
    DESCRIPTION = "Generate and edit images using Gemini 2.5 Flash Image"
    
    def tensor_to_pil(self, tensor: torch.Tensor) -> Image.Image:
        """Convierte tensor de ComfyUI a PIL Image"""
        if tensor.dim() == 4:
            tensor = tensor.squeeze(0)  # Remover dimensión batch
        
        # Convertir de tensor [H, W, C] a numpy
        np_image = tensor.cpu().numpy()
        
        # Asegurar valores en rango [0, 255]
        if np_image.max() <= 1.0:
            np_image = np_image * 255.0
        
        np_image = np_image.astype(np.uint8)
        
        # Convertir a PIL Image
        if np_image.shape[2] == 3:  # RGB
            return Image.fromarray(np_image, 'RGB')
        elif np_image.shape[2] == 4:  # RGBA
            return Image.fromarray(np_image, 'RGBA')
        else:
            # Manejar escala de grises
            return Image.fromarray(np_image[:,:,0], 'L')
    
    def pil_to_tensor(self, pil_image: Image.Image) -> torch.Tensor:
        """Convierte PIL Image a tensor de ComfyUI"""
        # Asegurar formato RGB
        if pil_image.mode != 'RGB':
            pil_image = pil_image.convert('RGB')
        
        # Convertir a numpy array
        np_image = np.array(pil_image).astype(np.float32) / 255.0
        
        # Convertir a tensor con dimensión batch [1, H, W, C]
        tensor = torch.from_numpy(np_image)[None,]
        
        return tensor
    
    def get_optimized_prompt(self, mode: str, custom_prompt: str) -> str:
        """Obtiene prompts optimizados según el modo seleccionado"""
        mode_prompts = {
            "generate": custom_prompt,
            "edit": f"Edit the provided image based on this request: {custom_prompt}. Maintain the overall composition and only change what's specifically requested.",
            "character_consistency": f"Maintain the exact same character/subject from the reference image and {custom_prompt}. Preserve all facial features, clothing, distinctive characteristics, and personality while adapting to the new context.",
            "multi_image_fusion": f"Seamlessly blend and merge elements from the provided images to create: {custom_prompt}. Maintain realistic lighting, perspective, and natural composition.",
            "prompt_based_editing": f"Make these specific targeted changes to the image: {custom_prompt}. Use precise local edits while preserving all other elements exactly as they are. Maintain photorealistic quality.",
            "world_knowledge": f"Using your comprehensive knowledge of the real world, {custom_prompt}. Ensure factual accuracy, realistic representation, and attention to real-world details.",
            "custom": custom_prompt
        }
        
        return mode_prompts.get(mode, custom_prompt)
    
    def prepare_contents(self, prompt: str, primary_image=None, reference_image=None, 
                        secondary_image=None, mask_image=None) -> List[Any]:
        """Prepara el contenido para la API de Gemini"""
        contents = [prompt]
        
        # Agregar imágenes en orden de prioridad
        images_to_process = [
            primary_image, reference_image, secondary_image, mask_image
        ]
        
        for image_tensor in images_to_process:
            if image_tensor is not None:
                try:
                    pil_image = self.tensor_to_pil(image_tensor)
                    contents.append(pil_image)
                except Exception as e:
                    print(f"⚠️ Error procesando imagen: {e}")
                    continue
        
        return contents
    
    def process_response(self, response) -> Tuple[Optional[Image.Image], str]:
        """Procesa la respuesta de Gemini y extrae imagen y texto"""
        generated_image = None
        text_response = ""
        
        try:
            if hasattr(response, 'candidates') and len(response.candidates) > 0:
                candidate = response.candidates[0]
                
                if hasattr(candidate, 'content') and candidate.content.parts:
                    for part in candidate.content.parts:
                        # Extraer texto
                        if hasattr(part, 'text') and part.text:
                            text_response += part.text + " "
                        
                        # Extraer imagen
                        elif hasattr(part, 'inline_data') and part.inline_data:
                            image_data = part.inline_data.data
                            generated_image = Image.open(io.BytesIO(image_data))
            
            # Limpiar texto
            text_response = text_response.strip()
            if not text_response:
                text_response = "Imagen generada exitosamente con Gemini 2.5 Flash Image"
                
        except Exception as e:
            text_response = f"Error procesando respuesta: {str(e)}"
            print(f"❌ Error en process_response: {e}")
        
        return generated_image, text_response
    
    def generate_with_gemini(self, api_key: str, prompt: str, mode: str, model: str, primary_image=None, reference_image=None, secondary_image=None, mask_image=None) -> Tuple:
        """Función principal para generar/editar imágenes con Gemini"""
        debug_info = []
        
        # Validar configuración de API
        try:
            self.initialize_client(api_key)
        except ValueError as e:
            error_msg = f"Error de inicialización de cliente Gemini: {e}"
            debug_info.append(error_msg)
            debug_str = " | ".join(debug_info)
            print(f"❌ {error_msg}")
            
            # Retornar imagen en negro en caso de error
            error_image = torch.zeros(1, 512, 512, 3)
            return (error_image, f"Error: {str(e)}", debug_str)
        
        try:
            # Obtener prompt optimizado
            final_prompt = self.get_optimized_prompt(mode, prompt)
            debug_info.append(f"Modo: {mode}")
            debug_info.append(f"Modelo: {model}")
            debug_info.append(f"Prompt optimizado: {final_prompt[:100]}...")
            
            # Preparar contenido
            contents = self.prepare_contents(
                final_prompt, 
                primary_image, 
                reference_image, 
                secondary_image, 
                mask_image
            )
            
            image_count = len([c for c in contents if isinstance(c, Image.Image)])
            debug_info.append(f"Imágenes de entrada: {image_count}")
            
            # Configurar parámetros de seguridad más permisivos
            safety_settings = {
                HarmCategory.HARM_CATEGORY_HARASSMENT: HarmBlockThreshold.BLOCK_NONE,
                HarmCategory.HARM_CATEGORY_HATE_SPEECH: HarmBlockThreshold.BLOCK_NONE,
                HarmCategory.HARM_CATEGORY_SEXUALLY_EXPLICIT: HarmBlockThreshold.BLOCK_MEDIUM_AND_ABOVE,
                HarmCategory.HARM_CATEGORY_DANGEROUS_CONTENT: HarmBlockThreshold.BLOCK_MEDIUM_AND_ABOVE,
            }
            
            # Realizar llamada a la API
            print("🚀 Enviando solicitud a Gemini 2.5 Flash Image...")
            response = self.client.generate_content(
                contents=contents,
                safety_settings=safety_settings,
                generation_config={
                    'temperature': 0.7,
                    'top_p': 0.9,
                    'top_k': 40,
                    'max_output_tokens': 2048,
                }
            )
            
            # Procesar respuesta
            generated_image, text_response = self.process_response(response)
            
            if generated_image:
                result_tensor = self.pil_to_tensor(generated_image)
                debug_info.append(f"Imagen generada: {generated_image.size}")
                debug_info.append("✅ Éxito: Generación completada")
            else:
                # Si no hay imagen, crear una imagen placeholder
                placeholder = Image.new('RGB', (512, 512), color=(100, 100, 100))
                result_tensor = self.pil_to_tensor(placeholder)
                debug_info.append("⚠️ No se generó imagen, usando placeholder")
                text_response = text_response or "No se pudo generar imagen"
            
            # Agregar información de costo
            debug_info.append("💰 Costo estimado: ~$0.039 por imagen")
            debug_info.append("🔒 Imagen incluye marca SynthID invisible")
            
            debug_str = " | ".join(debug_info)
            
            return (result_tensor, text_response, debug_str)
            
        except Exception as e:
            error_msg = f"Error en generación Gemini: {str(e)}"
            debug_info.append(error_msg)
            debug_str = " | ".join(debug_info)
            print(f"❌ {error_msg}")
            
            # Retornar imagen en negro en caso de error
            error_image = torch.zeros(1, 512, 512, 3)
            return (error_image, f"Error: {str(e)}", debug_str)


# Node registration for ComfyUI
NODE_CLASS_MAPPINGS = {
    "CL_GeminiFlash": CL_GeminiFlash
}

NODE_DISPLAY_NAME_MAPPINGS = {
    "CL_GeminiFlash": "CL Gemini Flash (by chelogarcho)"
}

# Export for ComfyUI
__all__ = ['NODE_CLASS_MAPPINGS', 'NODE_DISPLAY_NAME_MAPPINGS']

# Dependency information (for documentation)
DEPENDENCIES = [
    "google-generativeai>=0.8.0",
    "pillow>=9.0.0",
    "torch>=1.9.0",
    "numpy>=1.21.0"
]

# Installation instructions
INSTALLATION_INSTRUCTIONS = """
Installation Instructions for CL_GeminiFlash:

1. Copy this file to: ComfyUI/custom_nodes/CL_GeminiFlash.py

2. Install dependencies:
   pip install google-generativeai>=0.8.0 pillow>=9.0.0 torch>=1.9.0 numpy>=1.21.0

3. Restart ComfyUI

4. Search for "CL_GeminiFlash" or "chelogarcho" in ComfyUI

5. Get your Google API key from: https://aistudio.google.com/app/apikey

6. Paste your API key in the "api_key" field of the node

Usage:
- Select generation mode (generate, edit, character_consistency, etc.)
- Enter your prompt
- Optionally add reference images
- Generate with Gemini 2.5 Flash Image!

Modes Available:
- generate: Create new images from text
- edit: Edit existing images
- character_consistency: Maintain character across images
- multi_image_fusion: Blend multiple images
- prompt_based_editing: Targeted image editing
- world_knowledge: Use Gemini's world knowledge
- custom: Use your own custom prompt

Developer: chelogarcho
"""
