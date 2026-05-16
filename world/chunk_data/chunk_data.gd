class_name ChunkData
extends RefCounted

var DEBUG_CUBE_SIZE = Vector3i(16, 1, 16)

var voxels : Dictionary[Vector3i, VoxelInstance] = {}
var tile_position : Vector2i
var world : GameWorld

func _init():
	for x in DEBUG_CUBE_SIZE.x:
		for y in DEBUG_CUBE_SIZE.y:
			for z in DEBUG_CUBE_SIZE.z:
				voxels[Vector3i(x, y, z)] = VoxelInstance.new()
				
			
		

func chunk_to_grid_position(voxel_position : Vector3i) -> Vector3i:
	var grid_position : Vector3i
	var chunk_grid_position := tile_position * 16
	
	grid_position = Vector3i(chunk_grid_position.x, 0, chunk_grid_position.y) + voxel_position
	
	return grid_position

func grid_to_chunk_position(voxel_position : Vector3i) -> Vector3i:
	var grid_chunk_position : Vector2i = tile_position * world.CHUNK_SIZE
	
	var chunk_voxel_position :=  Vector3i(
		voxel_position.x - grid_chunk_position.x,
		voxel_position.y,
		voxel_position.z - grid_chunk_position.y
	)
	
	return chunk_voxel_position
