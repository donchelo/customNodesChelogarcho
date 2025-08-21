import os
import json
import base64
import io
import requests
from typing import Dict, Any, Optional, List
import openai
from openai import OpenAI
from PIL import Image
import torch
import numpy as np
from langdetect import detect, LangDetectException

class OpenAI_Simple_Chat:
    """
    Nodo para chat con OpenAI usando Responses API
    Procesa texto + imágenes y devuelve respuestas mejoradas en inglés
    """
    
    def __init__(self):
        self.client = None
        self.api_key = None
        
    @classmethod
    def INPUT_TYPES(cls):
        return {
            "required": {
                "user_prompt": ("STRING", {"default": "Enhance this image", "multiline": True}),
                "model": (["gpt-4o-mini", "gpt-4o", "gpt-4-turbo", "gpt-4"], {"default": "gpt-4o-mini"}),
                "max_characters": ("INT", {"default": 500, "min": 50, "max": 2000}),
                "system_prompt": ("STRING", {"default": "You are a helpful assistant that always responds in English. Enhance and improve the user's request with professional terminology.", "multiline": True}),
                "api_key": ("STRING", {"default": "", "multiline": False}),
            },
            "optional": {
                "image_1": ("IMAGE",),
                "image_2": ("IMAGE",),
                "image_3": ("IMAGE",),
                "use_env_key": ("BOOLEAN", {"default": True}),
            }
        }
    
    RETURN_TYPES = ("STRING",)
    RETURN_NAMES = ("response_text",)
    FUNCTION = "process_with_vision"
    CATEGORY = "AI/Chat"
    
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
            if not text or len(text.strip()) < 3:
                return "en"  # Default a inglés si texto muy corto
            
            detected = detect(text)
            return detected
        except LangDetectException:
            return "en"  # Default a inglés si no se puede detectar
        except Exception:
            return "en"
    
    def process_with_vision(self, user_prompt: str, model: str, max_characters: int, 
                           system_prompt: str, api_key: str, image_1=None, image_2=None, 
                           image_3=None, use_env_key: bool = True) -> tuple:
        """
        Procesa texto + imágenes con OpenAI Responses API
        Devuelve respuesta mejorada siempre en inglés
        """
        try:
            # Obtener la clave API
            if use_env_key:
                self.api_key = os.getenv("OPENAI_API_KEY")
                if not self.api_key:
                    return ("Error: OPENAI_API_KEY no encontrada en variables de entorno",)
            else:
                self.api_key = api_key
                if not self.api_key:
                    return ("Error: Clave API requerida",)
            
            # Inicializar cliente OpenAI
            self.client = OpenAI(api_key=self.api_key)
            
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
            
            # Realizar llamada a OpenAI Responses API
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

class OpenAI_Conversation_Chat:
    """
    Nodo para chat con conversación persistente usando Responses API
    Mantiene el historial de la conversación con soporte para imágenes
    """
    
    def __init__(self):
        self.client = None
        self.api_key = None
        self.conversation_history = []
        
    @classmethod
    def INPUT_TYPES(cls):
        return {
            "required": {
                "user_prompt": ("STRING", {"default": "Enhance this image", "multiline": True}),
                "model": (["gpt-4o-mini", "gpt-4o", "gpt-4-turbo", "gpt-4"], {"default": "gpt-4o-mini"}),
                "max_characters": ("INT", {"default": 500, "min": 50, "max": 2000}),
                "system_prompt": ("STRING", {"default": "You are a helpful assistant that always responds in English. Enhance and improve the user's request with professional terminology.", "multiline": True}),
                "api_key": ("STRING", {"default": "", "multiline": False}),
            },
            "optional": {
                "image_1": ("IMAGE",),
                "image_2": ("IMAGE",),
                "image_3": ("IMAGE",),
                "use_env_key": ("BOOLEAN", {"default": True}),
                "clear_history": ("BOOLEAN", {"default": False}),
            }
        }
    
    RETURN_TYPES = ("STRING", "STRING")
    RETURN_NAMES = ("response_text", "conversation_summary")
    FUNCTION = "conversation_with_vision"
    CATEGORY = "AI/Chat"
    
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
            if not text or len(text.strip()) < 3:
                return "en"
            
            detected = detect(text)
            return detected
        except LangDetectException:
            return "en"
        except Exception:
            return "en"
    
    def conversation_with_vision(self, user_prompt: str, model: str, max_characters: int, 
                                system_prompt: str, api_key: str, image_1=None, image_2=None, 
                                image_3=None, use_env_key: bool = True, clear_history: bool = False) -> tuple:
        """
        Procesa conversación con imágenes usando OpenAI Responses API
        """
        try:
            # Limpiar historial si se solicita
            if clear_history:
                self.conversation_history = []
            
            # Obtener la clave API
            if use_env_key:
                self.api_key = os.getenv("OPENAI_API_KEY")
                if not self.api_key:
                    return ("Error: OPENAI_API_KEY no encontrada en variables de entorno", "")
            else:
                self.api_key = api_key
                if not self.api_key:
                    return ("Error: Clave API requerida", "")
            
            # Inicializar cliente OpenAI
            self.client = OpenAI(api_key=self.api_key)
            
            # Detectar idioma del prompt del usuario
            detected_lang = self.detect_language(user_prompt)
            print(f"Idioma detectado: {detected_lang}")
            
            # Preparar mensajes con historial
            messages = [{"role": "system", "content": system_prompt}]
            
            # Agregar historial de conversación
            for msg in self.conversation_history:
                messages.append(msg)
            
            # Preparar contenido actual con imágenes
            content = []
            content.append({
                "type": "text",
                "text": f"User request (detected language: {detected_lang}): {user_prompt}\n\nPlease respond in English with a maximum of {max_characters} characters."
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
                        print(f"Imagen {i+1} agregada a conversación")
                except Exception as e:
                    print(f"Error procesando imagen {i+1}: {str(e)}")
            
            # Agregar mensaje actual
            messages.append({"role": "user", "content": content})
            
            # Realizar la llamada a la API
            response = self.client.chat.completions.create(
                model=model,
                messages=messages,
                max_tokens=max_characters * 2,
                temperature=0.7
            )
            
            # Extraer la respuesta
            ai_response = response.choices[0].message.content.strip()
            
            # Asegurar que la respuesta esté en inglés y respete el límite de caracteres
            if len(ai_response) > max_characters:
                ai_response = ai_response[:max_characters].rsplit(' ', 1)[0] + "..."
            
            # Verificar que la respuesta esté en inglés
            response_lang = self.detect_language(ai_response)
            if response_lang != "en":
                print(f"Advertencia: Respuesta detectada en {response_lang}, forzando inglés")
                ai_response = f"English response: {ai_response}"
                if len(ai_response) > max_characters:
                    ai_response = ai_response[:max_characters].rsplit(' ', 1)[0] + "..."
            
            # Actualizar historial de conversación (solo texto, no imágenes)
            self.conversation_history.append({"role": "user", "content": user_prompt})
            self.conversation_history.append({"role": "assistant", "content": ai_response})
            
            # Limitar el historial para evitar tokens excesivos
            if len(self.conversation_history) > 20:  # Máximo 10 intercambios
                self.conversation_history = self.conversation_history[-20:]
            
            # Crear resumen de conversación
            conversation_summary = ""
            for i in range(0, len(self.conversation_history), 2):
                if i + 1 < len(self.conversation_history):
                    conversation_summary += f"User: {self.conversation_history[i]['content']}\n"
                    conversation_summary += f"Assistant: {self.conversation_history[i+1]['content']}\n\n"
            
            # Información de uso
            usage_info = f"Tokens: {response.usage.total_tokens} | Caracteres: {len(ai_response)}/{max_characters} | Mensajes: {len(self.conversation_history)//2}"
            print(f"Conversación exitosa - {usage_info}")
            
            return ai_response, conversation_summary
            
        except openai.AuthenticationError:
            return ("Error: Clave API inválida", "")
        except openai.RateLimitError:
            return ("Error: Límite de tasa excedido", "")
        except openai.APIError as e:
            return (f"Error de API: {str(e)}", "")
        except Exception as e:
            return (f"Error inesperado: {str(e)}", "")

# Nodos disponibles para registro
NODE_CLASS_MAPPINGS = {
    "OpenAI_Simple_Chat": OpenAI_Simple_Chat,
    "OpenAI_Conversation_Chat": OpenAI_Conversation_Chat,
}

NODE_DISPLAY_NAME_MAPPINGS = {
    "OpenAI_Simple_Chat": "OpenAI Simple Chat",
    "OpenAI_Conversation_Chat": "OpenAI Conversation Chat",
}
