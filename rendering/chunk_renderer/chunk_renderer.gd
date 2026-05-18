## Renders a chunk.
class_name ChunkRenderer
extends Node3D

const CHUNK_MULTIMESH_TEMPLATE = preload("uid://dqgmtsxxs35rb")
const SHADER_MATERIAL = preload("res://world/game_world/quad.tres::ShaderMaterial_6dmd8")

@onready var chunk_mesh = $ChunkMesh
@onready var chunk_collision_shape = $ChunkCollision/CollisionShape3D

var voxel_mesher := VoxelMesher.new()
var loaded_chunk_data : ChunkData
var chunk_multimesh : MultiMesh = CHUNK_MULTIMESH_TEMPLATE.duplicate()

# Called when the node enters the scene tree for the first time.
func _ready():
	chunk_mesh.multimesh = chunk_multimesh

func update_chunk():
	if loaded_chunk_data == null:
		push_warning("["+name+"] Attempt to update chunk renderer with no chunk data.")
		return
	
	var results = voxel_mesher.generate_chunk_multimesh(loaded_chunk_data, loaded_chunk_data.world)
	var currentIndex = 0
	
	# Render voxel multimeshes
	for voxelPosition in results.instances:
		var voxelDirection = results.instances[voxelPosition]
		
		var voxelBasis = Basis(Quaternion(Vector3.UP, voxelDirection))
		
		if voxelDirection.x != 0:
			voxelBasis = voxelBasis.rotated(Vector3.RIGHT, deg_to_rad(90)).orthonormalized()
		
		var voxelTransform = Transform3D(voxelBasis, voxelPosition)
		
		chunk_multimesh.set_instance_transform(currentIndex, voxelTransform)
		
		currentIndex += 1
	
	chunk_multimesh.visible_instance_count = currentIndex
	
	var voxel_shape := ConcavePolygonShape3D.new()
	voxel_shape.set_faces(results.vertices)
	
	chunk_collision_shape.shape = voxel_shape

func load_chunk(chunk_data : ChunkData):
	loaded_chunk_data = chunk_data
	
	
