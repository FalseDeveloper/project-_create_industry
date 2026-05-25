## Renders a chunk.
class_name ChunkRenderer
extends Node3D

const CHUNK_MULTIMESH_TEMPLATE = preload("uid://dqgmtsxxs35rb")

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
	var current_index = 0
	
	# Render voxel multimeshes
	for voxel_surface : Types.VoxelSurface in results.mesh_instances:
		var surface_direction := voxel_surface.direction
		var surface_position := voxel_surface.position
		var surface_basis := Basis(Quaternion(Vector3.UP, surface_direction))
		var v_instance : VoxelInstance = results.mesh_instance_to_voxel[voxel_surface]
		
		if surface_direction.x != 0:
			surface_basis = surface_basis.rotated(Vector3.RIGHT, deg_to_rad(90)).orthonormalized()
		
		var surface_transform := Transform3D(surface_basis, Vector3(surface_position) + Vector3(surface_direction)/2)
		
		chunk_multimesh.set_instance_transform(current_index, surface_transform)
		
		var v_data = VoxelDatabase.get_data_from_name(v_instance.name)
		
		if v_data is DecorativeVoxelData:
			chunk_multimesh.set_instance_custom_data(current_index, Color(
				TextureDatabase.name_to_index.get(v_data.texture), 
				0, 0, 0
				))
		
		current_index += 1
	
	chunk_multimesh.visible_instance_count = current_index
	
	var voxel_shape := ConcavePolygonShape3D.new()
	voxel_shape.set_faces(results.vertices)
	
	chunk_collision_shape.shape = voxel_shape

func load_chunk(chunk_data : ChunkData):
	loaded_chunk_data = chunk_data
	
	
