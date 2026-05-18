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

const CHUNK_RENDERER := preload("uid://cdl3f21ang6qs")
const CHUNK_SIZE := Vector2i(16, 16)

@onready var chunk_renderers = $ChunkRenderers

var chunks : Dictionary[Vector2i, ChunkData] = {}
var renderers : Dictionary[ChunkData, ChunkRenderer] = {}

func create_chunk(tile : Vector2i, chunk_data : ChunkData = ChunkData.new()):
	if chunks.get(tile):
		push_error("Attempt to create chunk at already existing position", tile, "!")
	
	chunk_data.world = self
	chunk_data.tile_position = tile
	
	chunks[tile] = chunk_data
	
	var chunk_renderer : ChunkRenderer = CHUNK_RENDERER.instantiate()
	renderers[chunk_data] = chunk_renderer
	
	chunk_renderer.position = Vector3(tile.x * 16, 0, tile.y * 16)
	chunk_renderers.add_child(chunk_renderer) 
	
	chunk_renderer.load_chunk(chunk_data)

func get_chunk_at_voxel_position(voxel_position : Vector3i) -> ChunkData:
	var chunk_tile := Vector2i(
		floori(float(voxel_position.x) / CHUNK_SIZE.x),
		floori(float(voxel_position.z) / CHUNK_SIZE.y)
	)
		
	var chunk_data : ChunkData = chunks.get(chunk_tile)
	return chunk_data

func get_voxel_at_position(voxel_position : Vector3i) -> VoxelInstance:
	var chunk_data = get_chunk_at_voxel_position(voxel_position)
	
	if not chunk_data:
		return
	
	var chunk_voxel_position = chunk_data.grid_to_chunk_position(voxel_position)
	
	var voxel_at_position = chunk_data.voxels.get(chunk_voxel_position)
	
	return voxel_at_position

func world_to_grid_space(world_position : Vector3) -> Vector3i:
	var grid_position := Vector3i(
		round(world_position.x),
		round(world_position.y),
		round(world_position.z)
	)
	
	return grid_position

func grid_to_world_space(grid_position : Vector3) -> Vector3:
	return Vector3(grid_position) + Vector3.ONE/2

func get_neighboring_chunks(tile_position : Vector2i) -> Array[ChunkData]:
	var neighbors : Array[ChunkData] = []
	
	for direction : Vector2 in Utils.AXIS_DIRECTIONS_2D.values():
		var other_chunk : ChunkData = chunks.get(Vector2(tile_position) + direction)
		if other_chunk != null:
			neighbors.append(other_chunk)
	
	return neighbors

func set_voxel(voxel_position : Vector3i, voxel_id : StringName = "AIR"):
	var chunk_at_position = get_chunk_at_voxel_position(voxel_position)
	if chunk_at_position == null:
		return
	
	var voxel_chunk_position = chunk_at_position.grid_to_chunk_position(voxel_position)
	
	if voxel_id == "AIR":
		chunk_at_position.voxels.erase(voxel_chunk_position)
	else:
		chunk_at_position.voxels.set(voxel_chunk_position, VoxelInstance.new())
	
	renderers[chunk_at_position].update_chunk()
	
	for neighbor in get_neighboring_chunks(chunk_at_position.tile_position):
		renderers[neighbor].update_chunk()

func _ready():
	for x in 8:
		for y in 8:
			create_chunk(Vector2i(x - 4, y - 4))
	
	for chunk : ChunkData in chunks.values():
		renderers[chunk].update_chunk()

func _process(_delta):
	pass
