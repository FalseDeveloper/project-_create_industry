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
	
	var grid_chunk_position : Vector2i = chunk_data.tile_position * CHUNK_SIZE
	var chunk_voxel_position :=  Vector3i(
		voxel_position.x - grid_chunk_position.x,
		voxel_position.y,
		voxel_position.z - grid_chunk_position.y
	)
	
	var voxel_at_position = chunk_data.voxels.get(chunk_voxel_position)
	
	return voxel_at_position

func set_voxel(voxel_position : Vector3i):
	var chunk_at_position = get_chunk_at_voxel_position(voxel_position)
	
	

func _ready():
	for x in 8:
		for y in 8:
			create_chunk(Vector2i(x - 4, y - 4))
	
	for chunk : ChunkData in chunks.values():
		renderers[chunk].update_chunk()

func _process(_delta):
	pass
