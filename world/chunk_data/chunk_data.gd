class_name ChunkData
extends RefCounted

var DEBUG_CUBE_SIZE = Vector3i(16, 1, 16)

var voxels : Dictionary[Vector3i, VoxelInstance] = {}

func _init():
	for x in DEBUG_CUBE_SIZE.x:
		for y in DEBUG_CUBE_SIZE.y:
			for z in DEBUG_CUBE_SIZE.z:
				voxels[Vector3i(x, y, z)] = VoxelInstance.new()
				
			
		
