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
