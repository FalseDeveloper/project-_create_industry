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
@onready var collision_shape_3d = $VoxelCollision/CollisionShape3D

var quad_mesh = load("res://world/game_world/quad.tres")

func _ready():
	var debugChunk = ChunkData.new()
	
	var results = VoxelMesher.new().generate_chunk_multimesh(debugChunk)
	
	var voxel_multimesh = voxel_mesh.multimesh
	
	var currentIndex = 0
	
	for voxelPosition in results.instances:
		var voxelDirection = results.instances[voxelPosition]
		
		var voxelBasis = Basis(Quaternion(Vector3.UP, voxelDirection))
		
		if voxelDirection.x != 0:
			voxelBasis = voxelBasis.rotated(Vector3.RIGHT, deg_to_rad(90)).orthonormalized()
		
		var voxelTransform = Transform3D(voxelBasis, voxelPosition)
		
		voxel_multimesh.set_instance_transform(currentIndex, voxelTransform)
		
		currentIndex += 1
	
	voxel_multimesh.visible_instance_count = currentIndex
	
	var voxel_shape = ConvexPolygonShape3D.new()
	voxel_shape.points = results.vertices
	
	collision_shape_3d.shape = voxel_shape

func _process(_delta):
	
	pass
