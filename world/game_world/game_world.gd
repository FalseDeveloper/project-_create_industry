class_name GameWorld
extends Node3D

# -- Data Structure --
#
# NOTE: A GameWorld stores:
# - Chunks
# - - VoxelInstances (Decorative, Collision)
# - - VisualTileEntities (Animated, Decorative, Refers to TileEntityId)
# - Tile Entities (Simulation, has components)
# - get_voxel_at_position() : Returns either of the above. 
#

@onready var voxel_mesh = $VoxelMesh

func _ready():
	var arrayMesh = VoxelMesher.new().generate_chunk_mesh(0)
	
	voxel_mesh.mesh = arrayMesh

func _process(_delta):
	
	pass
