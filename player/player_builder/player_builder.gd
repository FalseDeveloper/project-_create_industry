class_name PlayerBuilder
extends Node

const VOXEL_SHAPE = preload("uid://bxhyyg24d2nbp")

@export var build_range = 5
@export var player : Player
@export_flags_3d_physics var verifier_collision_mask

@onready var aimer = $Aimer
@onready var voxel_name = $BuilderHUD/VoxelName

var verifier_box := BoxShape3D.new()
var selector_voxel_texture := preload("uid://bna75uf4wc6ba")

var selected_voxel = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	set_selected_voxel(selected_voxel)

func _process(_delta):
	var targeted_surface := get_targeted_surface()
		
	aimer.visible = targeted_surface != null
	
	if targeted_surface:
		aimer.position = targeted_surface.position
		

## Get the surface targeted by the player
func get_targeted_surface() -> Types.VoxelSurface:
	var targeted_surface : Types.VoxelSurface = Types.VoxelSurface.new()
	
	var mouse_pos = get_viewport().get_mouse_position()
	
	var ray_origin = player.camera_controller.project_ray_origin(mouse_pos)
	var ray_dir = player.camera_controller.project_ray_normal(mouse_pos)
	
	var space_state = player.get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_origin + (ray_dir * build_range))
	var result = space_state.intersect_ray(query)
	
	if result.get("position"):
		var direction := Utils.get_snapped_direction(result.normal)
		var targeted_position : Vector3 = result.position - (result.normal * 0.01)
		var targeted_voxel := player.game_world.world_to_grid_space(targeted_position)
		
		targeted_surface.position = targeted_voxel
		targeted_surface.direction = direction
		
		return targeted_surface
	
	return null

## Set the select voxel id
func set_selected_voxel(id : int):
	if id > VoxelDatabase.voxel_count - 1:
		id = 0
	elif id < 0:
		id = VoxelDatabase.voxel_count - 1
	
	var voxel_img := TextureDatabase.get_image_from_id(id)
	selector_voxel_texture.set_shader_parameter("texture_albedo", ImageTexture.create_from_image(voxel_img))
	
	voxel_name.text = str(id) + ":" + TextureDatabase.index_to_name[id]
	selected_voxel = id

## Attempt to place the selected voxel
func place_voxel():
	var targeted_surface : Types.VoxelSurface = get_targeted_surface()
	
	if targeted_surface:
		var voxel_at_pos = player.game_world.get_voxel_at_position(targeted_surface.position + targeted_surface.direction)
		if voxel_at_pos != null:
			return
		
		var space_state := player.get_world_3d().direct_space_state
		var params := PhysicsShapeQueryParameters3D.new()
		params.collision_mask = verifier_collision_mask
		params.shape = VOXEL_SHAPE
		params.transform = Transform3D(Basis.IDENTITY, Vector3(targeted_surface.position + targeted_surface.direction))
		
		var result := space_state.intersect_shape(params, 1)
		
		if !result.is_empty():
			return
		
		player.game_world.set_voxel(
			targeted_surface.position + targeted_surface.direction, 
			VoxelDatabase.id_to_name[selected_voxel]
		)

func _input(event):
	if event.is_action_pressed("Place"):
		# Attempt to place the selected voxel
		place_voxel()
		
	elif event.is_action_pressed("Next"):
		# Select next voxel in list
		set_selected_voxel(selected_voxel + 1)
		
	elif event.is_action_pressed("Previous"):
		# Select previous voxel in list
		set_selected_voxel(selected_voxel - 1)
		
	elif event.is_action_pressed("Destroy"):
		var targeted_surface : Types.VoxelSurface = get_targeted_surface()
		
		if targeted_surface:
			player.game_world.set_voxel(targeted_surface.position, "AIR")
		
