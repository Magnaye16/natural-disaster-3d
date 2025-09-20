shader_type canvas_item;

// 🌑 Dimming (0 = normal, 0.8 = darkest)
uniform float dim_strength : hint_range(0.0, 0.8) = 0.5;

// ⚡ Flash (0 = normal, 1 = full white)
uniform float flash_strength : hint_range(0.0, 1.0) = 0.0;

// 🌈 Tint sampled from gradient
uniform sampler2D GRADIENT : source_color, filter_linear_mipmap;
uniform float tint_pos : hint_range(0.0, 1.0) = 0.5; // where to sample in gradient
uniform float tint_strength : hint_range(0.0, 1.0) = 0.5; // blend amount

// 🖼️ Screen input
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
    // Step 1: Screen base
    vec4 screen_color = texture(SCREEN_TEXTURE, SCREEN_UV);

    // Step 2: Sample one tint color from gradient
    vec4 tint_color = texture(GRADIENT, vec2(tint_pos, 0.0));

    // Overlay tint (lerp between original and flat tint color)
    vec4 tinted = screen_color + (tint_color) * (tint_strength/2.0);

    // Step 3: Apply dimming (blend towards black)
    vec4 dimmed = mix(tinted, vec4(0.0, 0.0, 0.0, 1.0), min(dim_strength,0.8));

    // Step 4: Apply flash (blend towards white)
    vec4 flash_color = vec4(1.0, 1.0, 1.0, 1.0);
    COLOR = mix(dimmed, flash_color, flash_strength);
}
