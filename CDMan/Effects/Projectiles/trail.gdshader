shader_type canvas_item;

uniform float pixelSize = 10.0;

void fragment()
{
    vec2 uv = UV - mod(UV, pixelSize * TEXTURE_PIXEL_SIZE);
    COLOR = texture(TEXTURE, uv);
}