## Container holding most voxel textures.
extends Node

const TEXTURE_RESOURCES_PATH : StringName = "res://data/textures"
const CHUNK_MATERIAL = preload("uid://pc3slxqyp2s2")

var texture_array := Texture2DArray.new()
var name_to_index : Dictionary[String, int] = {}
var index_to_name : Dictionary[int, String] = {}
var current_id : int = 0

func get_images_in_dir(path : String) -> Array[Image]:
	var images_in_dir : Array[Image] = []
	
	var list := ResourceLoader.list_directory(path)
	
	for deep_path : String in list:
		var full_path := path + "/" + deep_path
		
		if deep_path.get_extension() == "png":
			var new_texture : CompressedTexture2D = ResourceLoader.load(full_path, "Image")
			var new_image : Image = new_texture.get_image()
			
			if new_image.is_compressed():
				new_image.decompress()
			
			new_image.convert(Image.FORMAT_RGBA16)
			new_image.resource_name = deep_path.left(-4)
			new_image.clear_mipmaps()
			
			images_in_dir.append(new_image)
			
			name_to_index.set(deep_path.left(-4), current_id)
			index_to_name.set(current_id, deep_path.left(-4))
			current_id += 1
			
			print("\tLoaded texture: ", new_image.resource_name)
		elif deep_path[-1] == "/":
			images_in_dir.append_array(get_images_in_dir(full_path))
		
	
	return images_in_dir

func _ready():
	print("# Started Loading Textures #")
	
	# Preload textures.
	var preloaded_textures : Array[Image] = get_images_in_dir(TEXTURE_RESOURCES_PATH)
	
	texture_array.create_from_images(preloaded_textures)
	
	CHUNK_MATERIAL.set_shader_parameter("voxel_textures", texture_array)
	
	print("# Finished Loading Textures #")

func get_image_from_id(id : int) -> Image:
	var returned_image : Image
	
	returned_image = texture_array.get_layer_data(id)
	
	return returned_image

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
