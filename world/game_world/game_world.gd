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

# debug thingie
@onready var voxel_mesh = $VoxelMesh
var quad_mesh = load("res://world/game_world/quad.tres")

func _ready():
	var debugChunk = ChunkData.new()
	
	var instances = VoxelMesher.new().generate_chunk_multimesh(debugChunk)
	
	var voxel_multimesh = voxel_mesh.multimesh
	
	var currentIndex = 0
	
	for voxelPosition in instances:
		var voxelDirection = instances[voxelPosition]
		
		var voxelBasis = Basis(Quaternion(Vector3.UP, voxelDirection))
		
		if voxelDirection.x != 0:
			voxelBasis = voxelBasis.rotated(Vector3.RIGHT, deg_to_rad(90)).orthonormalized()
		
		var voxelTransform = Transform3D(voxelBasis, voxelPosition)
		
		voxel_multimesh.set_instance_transform(currentIndex, voxelTransform)
		
		currentIndex += 1

func _process(_delta):
	
	pass
