shader_type canvas_item;

uniform sampler2D dither_matrix: repeat_enable, filter_nearest;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform vec4 primary_color : source_color = vec4(1);
uniform vec4 secondary_color : source_color = vec4(0, 0, 0, 1);

uniform int levels = 3;
uniform float max_color_range = 1;

uniform int dither_scale = 2;
uniform float dithering_intensity = 0.2;

uniform float brightness = 1.0;
uniform float contrast = 1.0;

void fragment() {
    vec3 screen_color = textureLod(screen_texture, SCREEN_UV, 0.0).rgb;

    screen_color.rgb = mix(vec3(0.0), screen_color.rgb, brightness);
    screen_color.rgb = mix(vec3(0.5), screen_color.rgb, contrast);

	// COLOR.rgb = c;
	vec2 dither_matrix_size = vec2(textureSize(dither_matrix, 0)) * float(dither_scale);
	vec2 screen_size = vec2(textureSize(screen_texture, 0));
	vec2 dither_coords = SCREEN_UV * screen_size / dither_matrix_size;

	vec3 dither_matrix_color = textureLod(dither_matrix, dither_coords, 0.0).rgb;

	dither_matrix_color.rgb = mix(vec3(0.5), dither_matrix_color.rgb, dithering_intensity);

	float screen_value = screen_color.r + screen_color.g + screen_color.b / 3.0;
	float dither_value = dither_matrix_color.r + dither_matrix_color.g + dither_matrix_color.b / 3.0;

	float combined_value = smoothstep(screen_value - max_color_range, screen_value + max_color_range, dither_value);
	vec4 col = mix(primary_color, secondary_color, combined_value);
	COLOR = col;
}