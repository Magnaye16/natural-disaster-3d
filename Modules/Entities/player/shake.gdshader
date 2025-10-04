shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform float intensity = 1.0;


void vertex() {
	VERTEX.x += sin(TIME * 10.0 * intensity);
}
