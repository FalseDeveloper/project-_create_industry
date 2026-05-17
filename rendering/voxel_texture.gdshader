shader_type spatial;

uniform sampler2D block_texture;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 texture_color = texture(block_texture, UV);
	
	ALBEDO = vec3(texture_color.x, texture_color.y, texture_color.z);
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
