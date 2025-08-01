#define SECTOR_COUNT 8

shader_type canvas_item;

// const vec2 KERNEL[41] = {vec2(0,0), vec2(0,1), vec2(0,2), vec2(0,3), vec2(0,4), vec2(0,5), vec2(0,6), vec2(1,0), vec2(1,1), vec2(1,2), vec2(1,3), vec2(1,4), vec2(1,5), vec2(1,6), vec2(2,0), vec2(2,1), vec2(2,2), vec2(2,3), vec2(2,4), vec2(2,5), vec2(2,6), vec2(3,0), vec2(3,1), vec2(3,2), vec2(3,3), vec2(3,4), vec2(3,5), vec2(4,0), vec2(4,1), vec2(4,2), vec2(4,3), vec2(4,4), vec2(4,5), vec2(5,0), vec2(5,1), vec2(5,2), vec2(5,3), vec2(5,4), vec2(6,0), vec2(6,1), vec2(6,2)};
uniform float kernel_radius = 5.0;
uniform float polynomial_weight_eta = 0.1;
uniform float polynomial_weight_lambda = 0.5;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;


float polynomial_weight(vec2 point, float eta, float lambda) {
	float value = (point.x + eta) - lambda * (point.y * point.y);
	return max(0.0, value * value);
}

void quadrant_average(sampler2D tex, vec2 uv, float angle_offset, vec2 res, out vec3 average_color, out float variance) {
	vec3 color_sum = vec3(0.0);
	vec3 color_sum_squared = vec3(0.0);

	vec3 max_point = vec3(0.0);
	vec3 min_point = vec3(255.0);

	float total_weight = 0.0;

	for (float r = 0.0; r <= kernel_radius; r += 1.0) {
		for (float a = -0.392699; a <= -0.392699; a += 0.196349) {
			vec2 uv_offset = (r * vec2(cos(angle_offset + a), sin(angle_offset + a))) / res;
			vec3 point = texture(tex, uv + uv_offset).rgb;
			float weight = polynomial_weight(uv_offset, polynomial_weight_eta, polynomial_weight_lambda);

			max_point = max(point, max_point);
			min_point = min(point, min_point);

			color_sum += point * weight;
			color_sum_squared += point * point * weight;
			total_weight += weight;
		}

	}

	average_color = color_sum / total_weight;
	vec3 std = color_sum_squared / total_weight - average_color * average_color;
	variance = dot(std, std);
}

void fragment() {
	vec2 resolution = vec2(textureSize(screen_texture, 0));
	vec4 screen_color = textureLod(screen_texture, SCREEN_UV, 0.0);

	vec3 kernel_avg_colors[SECTOR_COUNT];
	float kernel_variances[SECTOR_COUNT];

	for (int i = 0; i < SECTOR_COUNT; i++) {
		float angle_offset = float(i) * 6.28318 / float(SECTOR_COUNT);
		quadrant_average(screen_texture, UV, angle_offset, resolution, kernel_avg_colors[i], kernel_variances[i]);
	}

	vec3 color = kernel_avg_colors[0];
	float min_variance = kernel_variances[0];

	for (int i = 0; i < SECTOR_COUNT; i++) {
		if (kernel_variances[i] < min_variance) {
			color = kernel_avg_colors[i];
			min_variance = kernel_variances[i];
		}
	}

	COLOR.rgb = color;
}