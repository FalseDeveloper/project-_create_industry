shader_type spatial;

uniform sampler2D block_texture : filter_nearest;

void vertex() {
	
}

void fragment() {
	vec3 texture_color = texture(block_texture, UV).xyz;
	
	ALBEDO = texture_color;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
