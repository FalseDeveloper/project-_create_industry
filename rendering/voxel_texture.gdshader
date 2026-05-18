shader_type spatial;

uniform sampler2D block_texture : filter_nearest;
uniform sampler2D screen_texture : hint_screen_texture;
uniform sampler2DArray voxel_textures : filter_nearest_mipmap;

varying vec4 custom_data;

void vertex() {
	custom_data = INSTANCE_CUSTOM;
}

void fragment() {
	vec4 voxel_texture = texture(voxel_textures, vec3(UV.x, UV.y, custom_data.x));
	
	ALBEDO = voxel_texture.xyz;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
