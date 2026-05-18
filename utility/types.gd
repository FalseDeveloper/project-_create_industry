class_name Types
extends Node

enum VoxelDataType {
	TILE_ENTITY,
	DECORATIVE,
	VISUAL_TILE_ENTITY,
}

class VoxelSurface:
	var position : Vector3i
	var direction : Vector3i
	
	func _init(pos : Vector3i = Vector3i.ZERO, dir : Vector3i = Vector3i.UP):
		position = pos
		direction = dir
