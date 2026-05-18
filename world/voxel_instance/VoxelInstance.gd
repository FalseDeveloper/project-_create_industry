class_name VoxelInstance
extends RefCounted

var name : StringName = "stone"
var data : VoxelData

func _init(from_data : StringName = "stone"):
	var v_data = VoxelDatabase.get_data_from_name(from_data)
	
	if not v_data:
		push_error("Attempt to create voxel from invalid name ", from_data)
	
	name = from_data
	data = v_data
	
