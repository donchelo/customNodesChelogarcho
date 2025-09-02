"""
OpenAI Simple Chat - Custom Node para ComfyUI
Developer: chelogarcho
Allows integration of OpenAI chat directly in ComfyUI with image analysis capabilities
"""

"""
OpenAI Simple Chat - Custom Node para ComfyUI
Developer: chelogarcho
Allows integration of OpenAI chat directly in ComfyUI with image analysis capabilities
"""

from .openai_simple_chat import NODE_CLASS_MAPPINGS, NODE_DISPLAY_NAME_MAPPINGS

# Override display names to include developer info
NODE_DISPLAY_NAME_MAPPINGS = {
    "OpenAI_Simple_Chat": "OpenAI Simple Chat (by chelogarcho)"
}

__all__ = ['NODE_CLASS_MAPPINGS', 'NODE_DISPLAY_NAME_MAPPINGS']
