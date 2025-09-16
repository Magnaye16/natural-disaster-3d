shader_type canvas_item;

uniform float dim_strength : hint_range(0.0, 0.5) = 0.5;  // base dimming (0 = normal, 1 = fully dark)
uniform float flash_strength : hint_range(0.0, 1.0) = 0.0; // lightning flash strength
uniform vec4 tint_color : source_color = vec4(0.1, 0.15, 0.2, 1.0); // gloomy tint
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;



void fragment() {
    // Base scene color
    vec4 screen_color = texture(SCREEN_TEXTURE, SCREEN_UV);

    // Apply dimming (dark overlay with tint)
    vec3 dimmed = mix(screen_color.rgb, tint_color.rgb, dim_strength);

    // Apply lightning flash (brightens toward white)
    vec3 flashed = mix(dimmed, vec3(1.0), flash_strength);

    COLOR = vec4(flashed, screen_color.a);
}
