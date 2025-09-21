shader_type canvas_item;

uniform float dim_strength : hint_range(0.0, 0.8) = 0.5;

uniform float flash_strength : hint_range(0.0, 1.0) = 0.0;

uniform sampler2D GRADIENT : source_color, filter_linear_mipmap;
uniform float tint_pos : hint_range(0.0, 1.0) = 0.5; // where to sample in gradient
uniform float tint_strength : hint_range(0.0, 1.0) = 0.5; // blend amount

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
    vec4 screen_color = texture(SCREEN_TEXTURE, SCREEN_UV);

    vec4 tint_color = texture(GRADIENT, vec2(tint_pos, 0.0));

    vec4 tinted = screen_color + (tint_color) * (tint_strength/2.0);

    vec4 dimmed = mix(tinted, vec4(0.0, 0.0, 0.0, 1.0), clamp(dim_strength,0.2,0.9));

    vec4 flash_color = vec4(1.0, 1.0, 1.0, 1.0);
    COLOR = mix(dimmed, flash_color, flash_strength);
}
