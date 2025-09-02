"""
CL_VirtualTryOn - YourMirror Virtual Try-On Node
Developer: chelogarcho
Integrates with YourMirror.io API for virtual garment try-on functionality

This is a single-file ComfyUI node that consolidates all functionality.
Dependencies: requests>=2.28.0, pillow>=9.0.0, numpy>=1.21.0

Installation: Copy this file to ComfyUI/custom_nodes/
Usage: Search for "CL_VirtualTryOn" or "chelogarcho" in ComfyUI
"""

import requests
import numpy as np
import torch
from PIL import Image
import io
import tempfile
import os
import json
import time
import base64
from typing import Optional, Tuple, Dict, Any

# Try to import required packages, provide helpful error messages if not available
try:
    import requests
except ImportError:
    raise ImportError(
        "requests package is required for CL_VirtualTryOn node. "
        "Install with: pip install requests>=2.28.0"
    )

try:
    import numpy as np
except ImportError:
    raise ImportError(
        "numpy package is required for CL_VirtualTryOn node. "
        "Install with: pip install numpy>=1.21.0"
    )


class CL_VirtualTryOn:
    """
    YourMirror.io Virtual Try-On Node for ComfyUI
    Integrates with YourMirror.io API for virtual garment try-on functionality
    
    Developer: chelogarcho
    """
    
    def __init__(self):
        self.api_base_url = "https://apiservice.yourmirror.io"
        self.max_retries = 3
        self.timeout = 60
        self.user_agent = "ComfyUI-CL_VirtualTryOn/1.0"
        self.high_quality_timeout = None  # Optional override for high-quality calls
        self.download_timeout = 60  # Timeout for downloading result images
        self.log_messages = []  # Store log messages for output

    def log_debug(self, message: str):
        """Simple debug logging"""
        log_msg = f"[CL_VirtualTryOn DEBUG] {message}"
        print(log_msg)
        self.log_messages.append(log_msg)
        
    def log_error(self, message: str):
        """Simple error logging"""
        log_msg = f"[CL_VirtualTryOn ERROR] {message}"
        print(log_msg)
        self.log_messages.append(log_msg)
        
    def log_info(self, message: str):
        """Info logging"""
        log_msg = f"[CL_VirtualTryOn INFO] {message}"
        print(log_msg)
        self.log_messages.append(log_msg)
    
    @classmethod
    def INPUT_TYPES(cls):
        return {
            "required": {
                "api_key": ("STRING", {
                    "multiline": False,
                    "default": "",
                    "placeholder": "Enter your YourMirror.io API key"
                }),
                "base_image": ("IMAGE",),
                "product_image": ("IMAGE",),
                "workflow_type": (["eyewear", "footwear", "dress", "bottom", "top"],),
                "quality": (["normal", "high"],),
            },
            "optional": {
                "mask_image": ("IMAGE",),
            }
        }
    
    RETURN_TYPES = ("IMAGE", "STRING")
    RETURN_NAMES = ("result_image", "debug_logs")
    FUNCTION = "generate_tryon"
    CATEGORY = "chelogarcho/Virtual Try-On"
    DESCRIPTION = "Virtual try-on using YourMirror.io API"
    
    def tensor_to_pil(self, tensor: torch.Tensor) -> Image.Image:
        """Convert ComfyUI tensor to PIL Image"""
        if tensor.dim() == 4:
            tensor = tensor.squeeze(0)  # Remove batch dimension if present
        
        # Convert from (C, H, W) to (H, W, C) if needed
        if tensor.shape[0] == 3 or tensor.shape[0] == 4:
            tensor = tensor.permute(1, 2, 0)
        
        # Ensure values are in [0, 255] range
        if tensor.max() <= 1.0:
            tensor = tensor * 255.0
        
        # Convert to numpy and ensure uint8
        np_image = tensor.cpu().numpy().astype(np.uint8)
        
        # Handle different channel configurations
        if np_image.shape[-1] == 4:
            # RGBA
            return Image.fromarray(np_image, 'RGBA')
        elif np_image.shape[-1] == 3:
            # RGB
            return Image.fromarray(np_image, 'RGB')
        else:
            # Grayscale
            return Image.fromarray(np_image.squeeze(), 'L')
    
    def pil_to_tensor(self, image: Image.Image) -> torch.Tensor:
        """Convert PIL Image to ComfyUI tensor"""
        # Convert to RGB if necessary
        if image.mode != 'RGB':
            image = image.convert('RGB')
        
        # Convert to numpy array
        np_image = np.array(image).astype(np.float32) / 255.0
        
        # Convert to tensor and add batch dimension
        tensor = torch.from_numpy(np_image)
        tensor = tensor.unsqueeze(0)  # Add batch dimension
        
        return tensor
    
    def save_temp_image(self, pil_image: Image.Image, format: str = "PNG") -> str:
        """Save PIL image to temporary file and return file path"""
        temp_file = tempfile.NamedTemporaryFile(
            delete=False, 
            suffix=f".{format.lower()}", 
            prefix="cl_virtualtry_"
        )
        
        # Convert to RGB if saving as JPEG
        if format.upper() == "JPEG" and pil_image.mode in ("RGBA", "P"):
            # Create white background for transparency
            background = Image.new('RGB', pil_image.size, (255, 255, 255))
            if pil_image.mode == 'P':
                pil_image = pil_image.convert('RGBA')
            background.paste(pil_image, mask=pil_image.split()[-1] if pil_image.mode == 'RGBA' else None)
            pil_image = background
        
        pil_image.save(temp_file.name, format=format, quality=95)
        temp_file.close()
        
        # Debug: Log file path and check if file exists
        self.log_debug(f"Saved temp image: {temp_file.name}")
        self.log_debug(f"File exists: {os.path.exists(temp_file.name)}")
        self.log_debug(f"File size: {os.path.getsize(temp_file.name)} bytes")
        
        return temp_file.name

    def cleanup_temp_files(self, *file_paths):
        """Clean up temporary files"""
        for file_path in file_paths:
            if file_path and os.path.exists(file_path):
                try:
                    os.unlink(file_path)
                    self.log_debug(f"Cleaned up temp file: {file_path}")
                except Exception as e:
                    self.log_error(f"Could not delete temp file {file_path}: {e}")
    
    def file_to_base64(self, file_path: str) -> str:
        """Convert file to base64 string"""
        try:
            with open(file_path, 'rb') as file:
                file_data = file.read()
                base64_data = base64.b64encode(file_data).decode('utf-8')
                self.log_debug(f"Converted file to base64: {len(base64_data)} chars")
                return base64_data
        except Exception as e:
            self.log_error(f"Failed to convert file to base64: {e}")
            raise

    def prepare_file_payload_v4(self, file_path: str) -> Dict[str, Any]:
        """Try exact format from API documentation"""
        if file_path is None:
            return None
            
        # Use base64 data URL in path field (matching API docs format)
        base64_data = self.file_to_base64(file_path)
        data_url = f"data:image/png;base64,{base64_data}"
        return {
            "path": data_url,
            "meta": {"_type": "gradio.FileData"}
        }

    def make_api_request(self, payload: Dict[str, Any], retry_count: int = 0) -> Dict[str, Any]:
        """Make API request with retry logic"""
        try:
            headers = {
                'Content-Type': 'application/json',
                'User-Agent': self.user_agent,
            }
            
            # Debug: Log the payload structure
            self.log_debug(f"API Payload structure:")
            self.log_debug(f"  - Base image: data URI in path")
            self.log_debug(f"  - Product image: data URI in path")
            self.log_debug(f"  - Workflow type: {payload['data'][2]}")
            self.log_debug(f"  - Mask: {payload['data'][3]}")
            self.log_debug(f"  - Quality: {payload['data'][4]}")
            self.log_debug(f"  - API key length: {len(payload['data'][5])}")
            
            # Determine timeout considering quality (high quality typically needs longer)
            request_timeout = self.timeout
            try:
                if isinstance(payload.get('data'), list) and len(payload['data']) >= 5:
                    quality_value = payload['data'][4]
                    if isinstance(quality_value, str) and quality_value.lower() == 'high':
                        # Use explicit high-quality timeout if provided, otherwise ensure at least 180s
                        request_timeout = self.high_quality_timeout or max(self.timeout, 180)
                        self.log_debug(f"Adjusted timeout for high quality: {request_timeout}s")
            except Exception:
                # If anything goes wrong, fall back to default timeout
                request_timeout = self.timeout

            self.log_info(f"Making API request to: {self.api_base_url}/generate")
            response = requests.post(
                f"{self.api_base_url}/generate",
                json=payload,
                headers=headers,
                timeout=request_timeout
            )
            
            self.log_info(f"API Response Status: {response.status_code}")
            
            # Handle different response scenarios
            if response.status_code == 200:
                result = response.json()
                if 'error' in result:
                    raise Exception(f"API Error: {result['error']}")
                self.log_info("API request successful!")
                return result
            elif response.status_code == 429:  # Rate limit
                if retry_count < self.max_retries:
                    wait_time = (2 ** retry_count) * 5  # Exponential backoff
                    self.log_info(f"Rate limited. Waiting {wait_time} seconds before retry...")
                    time.sleep(wait_time)
                    return self.make_api_request(payload, retry_count + 1)
                else:
                    raise Exception("Rate limit exceeded. Please wait before making more requests.")
            else:
                # Debug: Log the full error response
                self.log_error(f"API Response Status: {response.status_code}")
                self.log_error(f"API Response Headers: {dict(response.headers)}")
                self.log_error(f"API Response Text: {response.text}")
                raise Exception(f"API request failed with status {response.status_code}: {response.text}")
                
        except requests.exceptions.Timeout:
            if retry_count < self.max_retries:
                self.log_info(f"Request timeout. Retrying... ({retry_count + 1}/{self.max_retries})")
                return self.make_api_request(payload, retry_count + 1)
            else:
                raise Exception("Request timed out after multiple retries")
        except requests.exceptions.RequestException as e:
            raise Exception(f"Network error: {str(e)}")
    
    def download_result_image(self, image_url: str) -> Image.Image:
        """Download the result image from the provided URL"""
        try:
            self.log_info(f"Downloading result image from: {image_url}")
            response = requests.get(image_url, timeout=self.download_timeout)
            response.raise_for_status()
            image = Image.open(io.BytesIO(response.content))
            self.log_info(f"Downloaded image: {image.size} pixels")
            return image
        except Exception as e:
            raise Exception(f"Failed to download result image: {str(e)}")
    
    def validate_inputs(self, base_image, product_image, workflow_type, quality, api_key, mask_image=None):
        """Validate all inputs before making API request"""
        if not api_key or api_key.strip() == "":
            raise ValueError("API key is required. Get your API key from yourmirror.io")
        
        if workflow_type not in ["eyewear", "footwear", "dress", "bottom", "top"]:
            raise ValueError(f"Invalid workflow type: {workflow_type}")
        
        if quality not in ["normal", "high"]:
            raise ValueError(f"Invalid quality setting: {quality}")
        
        if base_image is None:
            raise ValueError("Base image (person) is required")
        
        if product_image is None:
            raise ValueError("Product image (garment) is required")
    
    def generate_tryon(self, api_key, base_image, product_image, workflow_type, quality, mask_image=None):
        """Main function to generate virtual try-on"""
        temp_files = []
        
        # Clear previous log messages
        self.log_messages = []
        
        try:
            # Validate inputs
            self.validate_inputs(base_image, product_image, workflow_type, quality, api_key, mask_image)
            
            self.log_info(f"Starting YourMirror.io virtual try-on")
            self.log_debug(f"  - Workflow: {workflow_type}")
            self.log_debug(f"  - Quality: {quality}")
            self.log_debug(f"  - Has mask: {mask_image is not None}")
            
            # Convert tensors to PIL images
            base_pil = self.tensor_to_pil(base_image)
            product_pil = self.tensor_to_pil(product_image)
            mask_pil = self.tensor_to_pil(mask_image) if mask_image is not None else None
            
            self.log_debug(f"Image conversion completed")
            self.log_debug(f"  - Base image size: {base_pil.size}")
            self.log_debug(f"  - Product image size: {product_pil.size}")
            if mask_pil:
                self.log_debug(f"  - Mask image size: {mask_pil.size}")
            
            # Prepare images for API using base64 format
            self.log_info("Preparing images for API...")
            base_temp_file = self.save_temp_image(base_pil, "PNG")
            product_temp_file = self.save_temp_image(product_pil, "PNG")
            mask_temp_file = self.save_temp_image(mask_pil, "PNG") if mask_pil else None
            temp_files.extend([base_temp_file, product_temp_file])
            if mask_temp_file:
                temp_files.append(mask_temp_file)
            
            # Use base64 format for API
            payload = {
                "data": [
                    self.prepare_file_payload_v4(base_temp_file),
                    self.prepare_file_payload_v4(product_temp_file),
                    workflow_type,
                    self.prepare_file_payload_v4(mask_temp_file) if mask_temp_file else None,
                    quality,
                    api_key.strip()
                ]
            }
            
            # Make API request
            self.log_debug("Sending request to YourMirror.io API...")
            result = self.make_api_request(payload)
            
            # Extract result image URL
            if 'data' not in result or not result['data']:
                raise Exception("No image data returned from API")
            
            image_url = result['data'][0]
            self.log_debug(f"Downloading result from: {image_url}")
            
            # Download and convert result image
            result_pil = self.download_result_image(image_url)
            result_tensor = self.pil_to_tensor(result_pil)
            
            self.log_info("Virtual try-on completed successfully!")
            
            # Create debug logs string
            debug_logs = "\n".join(self.log_messages)
            
            return (result_tensor, debug_logs)
            
        except Exception as e:
            error_msg = str(e)
            self.log_error(f"YourMirror.io Error: {error_msg}")
            
            # Create error image with text
            error_image = Image.new('RGB', (512, 512), color=(220, 53, 69))  # Bootstrap danger red
            result_tensor = self.pil_to_tensor(error_image)
            
            # Create debug logs string
            debug_logs = "\n".join(self.log_messages)
            
            # Re-raise the exception so ComfyUI shows the error
            raise Exception(f"CL_VirtualTryOn Error: {error_msg}")
            
        finally:
            # Clean up temporary files
            self.cleanup_temp_files(*temp_files)


# Node registration for ComfyUI
NODE_CLASS_MAPPINGS = {
    "CL_VirtualTryOn": CL_VirtualTryOn
}

NODE_DISPLAY_NAME_MAPPINGS = {
    "CL_VirtualTryOn": "CL Virtual Try-On (by chelogarcho)"
}

# Export for ComfyUI
__all__ = ['NODE_CLASS_MAPPINGS', 'NODE_DISPLAY_NAME_MAPPINGS']

# Dependency information (for documentation)
DEPENDENCIES = [
    "requests>=2.28.0",
    "pillow>=9.0.0", 
    "numpy>=1.21.0"
]

# Installation instructions
INSTALLATION_INSTRUCTIONS = """
Installation Instructions for CL_VirtualTryOn:

1. Copy this file to: ComfyUI/custom_nodes/CL_VirtualTryOn.py

2. Install dependencies:
   pip install requests>=2.28.0 pillow>=9.0.0 numpy>=1.21.0

3. Restart ComfyUI

4. Search for "CL_VirtualTryOn" or "chelogarcho" in ComfyUI

5. Get your YourMirror.io API key from: https://yourmirror.io/

6. Paste your API key in the "api_key" field of the node

Usage:
- Load a base image (person)
- Load a product image (garment)
- Select workflow type (eyewear, footwear, dress, bottom, top)
- Select quality (normal, high)
- Optionally add a mask image
- Generate virtual try-on!

Developer: chelogarcho
"""
