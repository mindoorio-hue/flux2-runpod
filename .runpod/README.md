# FLUX.2 Image Generation - RunPod Serverless Template

Production-ready serverless endpoint for FLUX.2 image generation with text-to-image, image-to-image, and multi-reference workflows.

## Features

### 🎨 Complete Workflow Support
- **Text-to-Image**: Generate images from text prompts
- **Image-to-Image**: Transform existing images with strength control
- **Multi-Reference**: Combine multiple reference images with weighted influence

### 🚀 Dual Model Support
- **FLUX.2-dev**: High-quality generation (28-50 steps) - requires HuggingFace token
- **FLUX.2-schnell**: Fast generation (1-4 steps) - open access, no token needed

### ⚡ Performance Optimizations
- 4-bit quantization (NF4) for 44GB GPU compatibility
- Memory-efficient inference with attention slicing and VAE tiling
- Component-level CPU offload for optimal memory management
- bfloat16 precision for speed

## Quick Start

### 1. Environment Variables

**Required for FLUX.2-dev:**
```bash
HF_TOKEN=your_huggingface_token
```

**Optional:**
```bash
MODEL_NAME=black-forest-labs/FLUX.2-dev  # or FLUX.2-schnell
```

### 2. API Usage

**Text-to-Image:**
```json
{
  "input": {
    "prompt": "A beautiful mountain landscape at sunset, professional photography",
    "width": 1024,
    "height": 1024,
    "num_inference_steps": 50,
    "guidance_scale": 7.5,
    "seed": 42
  }
}
```

**Image-to-Image:**
```json
{
  "input": {
    "prompt": "Transform into watercolor painting style",
    "image": "base64_encoded_image_here",
    "strength": 0.8,
    "num_inference_steps": 50,
    "guidance_scale": 7.5
  }
}
```

**Multi-Reference:**
```json
{
  "input": {
    "prompt": "Combine these art styles into a unique composition",
    "reference_images": [
      {"image": "base64_image_1", "weight": 1.0},
      {"image": "base64_image_2", "weight": 0.5}
    ],
    "num_inference_steps": 50,
    "guidance_scale": 7.5
  }
}
```

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `prompt` | string | *required* | Text description of desired image |
| `negative_prompt` | string | - | What to avoid (FLUX.1 only) |
| `width` | int | 1024 | Image width (multiple of 8, max 2048) |
| `height` | int | 1024 | Image height (multiple of 8, max 2048) |
| `num_inference_steps` | int | 50/4 | Steps (dev: 28-50, schnell: 1-4) |
| `guidance_scale` | float | 7.5/3.5 | Prompt adherence (0.0-20.0) |
| `num_images` | int | 1 | Number of images to generate (1-4) |
| `seed` | int | random | Random seed for reproducibility |
| `output_format` | string | PNG | Output format (PNG/JPEG/WEBP) |

**Image-to-Image only:**
- `image`: Base64 encoded source image
- `strength`: Transformation strength (0.0-1.0, default 0.8)

**Multi-Reference only:**
- `reference_images`: Array of `{image: base64, weight: float}` objects

## Response Format

```json
{
  "status": "success",
  "images": ["base64_encoded_image_1", "base64_encoded_image_2"],
  "metadata": {
    "prompt": "original prompt",
    "model": "black-forest-labs/FLUX.2-dev",
    "seed": 42,
    "inference_time_seconds": 3.45,
    "num_images": 2,
    "workflow": "txt2img"
  }
}
```

## GPU Requirements

| Model | Minimum VRAM | Recommended GPU |
|-------|--------------|-----------------|
| FLUX.2-dev | 40GB | A100, A40, RTX 6000 Ada |
| FLUX.2-schnell | 40GB | A100, A40, RTX 6000 Ada |

With 4-bit quantization: ~22GB per model

## Error Handling

All errors return structured responses:
```json
{
  "status": "error",
  "error": "Error message",
  "traceback": "Full stack trace for debugging"
}
```

## Model Variants

### FLUX.2-dev
- **Quality**: Best
- **Speed**: Slower (28-50 steps)
- **Token**: Required (gated model)
- **Use case**: High-quality final outputs

### FLUX.2-schnell
- **Quality**: Good
- **Speed**: Fast (1-4 steps)
- **Token**: Not required
- **Use case**: Rapid prototyping, real-time generation

## Getting HuggingFace Token

1. Visit https://huggingface.co/settings/tokens
2. Create a new token with "Read" access
3. Accept the FLUX.2-dev model license at https://huggingface.co/black-forest-labs/FLUX.2-dev
4. Set token as `HF_TOKEN` environment variable

## License

This template uses Black Forest Labs FLUX.2 models. Review model-specific licenses:
- FLUX.2-dev: https://huggingface.co/black-forest-labs/FLUX.2-dev
- FLUX.2-schnell: https://huggingface.co/black-forest-labs/FLUX.2-schnell

## Support

For issues or questions:
- Check RunPod documentation: https://docs.runpod.io
- Review error messages in response payloads
- Verify HuggingFace token permissions
- Ensure GPU has sufficient VRAM
