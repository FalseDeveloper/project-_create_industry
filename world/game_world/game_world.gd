class_name GameWorld
extends Node3D

# -- Data Structure --
#
# NOTE: A GameWorld stores:
# - VisualChunks
# - - VoxelInstances (Decorative, Collision)
# - - VisualTileEntities (Animated, Decorative, Refers to TileEntityId)
# - Tile Entities (Simulation, has components)
# - get_voxel_at_position() : Returns either 
#
# NOTE: Our general data structure stores:
# - VoxelDataHash Dictionary [BlockId] : VoxelData
#
# NOTE: VoxelData is inherited by DecorativeVoxelData, TileEntityData & VisualTileEntityData

func _process(_delta):
	pass
