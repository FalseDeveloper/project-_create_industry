## Voxel database
extends Node

const VOXEL_RESOURCES_PATH = "res://data/voxels/voxel_resources/"

var registered_voxels : Array[VoxelData] = []
var name_to_id : Dictionary[StringName, int] = {}

var _current_id = 0

signal data_loaded

func get_voxels_in_dir(path : String) -> Array[VoxelData]:
	var voxels_in_dir : Array[VoxelData] = []
	
	var list := ResourceLoader.list_directory(path)
	
	for deep_path : String in list:	
		var full_path := path + "/" + deep_path
		
		if deep_path.get_extension() == "tres":
			var new_voxel : VoxelData = ResourceLoader.load(full_path)
			new_voxel.resource_name = deep_path.left(-5)
			
			voxels_in_dir.append(new_voxel)
			
			name_to_id.set(new_voxel.resource_name, _current_id)
			_current_id += 1
			
			print("Loaded voxel: ", new_voxel.resource_name)
		elif deep_path[-1] == "/":
			voxels_in_dir.append_array(get_voxels_in_dir(full_path))
	
	return voxels_in_dir

func get_data_from_name(voxel_name : StringName) -> VoxelData:
	return registered_voxels.get(name_to_id.get(voxel_name))

func _ready():
	var preloaded_voxels := get_voxels_in_dir(VOXEL_RESOURCES_PATH)
	
	print(preloaded_voxels)
	
	registered_voxels = preloaded_voxels
	
	data_loaded.emit()
