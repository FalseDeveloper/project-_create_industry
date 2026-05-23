shader_type spatial;

uniform sampler2DArray voxel_textures : filter_nearest, source_color;
varying flat int texture_index;

void vertex() {
	texture_index = int(INSTANCE_CUSTOM.x);
}

void fragment() {
	vec4 voxel_texture = texture(voxel_textures, vec3(UV.x, UV.y, float(texture_index)));
	
	//dumb fix
	ALBEDO = pow(voxel_texture.rgb, vec3(2.2));
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
