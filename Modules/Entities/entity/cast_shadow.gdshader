shader_type canvas_item;

uniform float radius : hint_range(0.0, 0.5) = 0.3;  // Circle radius (0–0.5 relative to sprite)
uniform float alpha  : hint_range(0.0, 1.0) = 0.5;  // Shadow opacity
const vec2 center = vec2(0.5, 0.5);              // Circle center (UV)
const float pixel_size = 1.0; // Pixel-art chunk size

void fragment() {
    // Quantize UVs for chunky pixel look
    ivec2 tsize = textureSize(TEXTURE, 0);
    vec2 tex_size = max(vec2(1.0), vec2(tsize));
    vec2 quant = max(vec2(1.0), vec2(pixel_size));
    vec2 uv = floor(UV * tex_size / quant) * quant / tex_size;

    // Distance from the circle center
    float dist = distance(uv, center);

    // Step function for circle edge
    float mask = step(dist, radius);

    // Output black shadow with alpha
    COLOR = vec4(0.0, 0.0, 0.0, mask * alpha);
}
