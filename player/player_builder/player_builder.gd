class_name PlayerBuilder
extends Node

const VOXEL_SHAPE = preload("uid://bxhyyg24d2nbp")

@export var build_range = 5
@export var player : Player
@export_flags_3d_physics var verifier_collision_mask

@onready var aimer = $Aimer

var verifier_box := BoxShape3D.new()
var selector_voxel_texture = preload("uid://bna75uf4wc6ba")

# Called when the node enters the scene tree for the first time.
func _ready():
	var block_id := TextureDatabase.name_to_index["dirt"]
	var block_img := TextureDatabase.get_image_from_id(block_id)
	
	selector_voxel_texture.albedo_texture = ImageTexture.create_from_image(block_img)

func _process(_delta):
	var targeted_surface := get_targeted_surface()
		
	aimer.visible = targeted_surface != null
	
	if targeted_surface:
		aimer.position = targeted_surface.position
		

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

func _input(event):	
	if event.is_action_pressed("Place"):
		var targeted_surface : Types.VoxelSurface = get_targeted_surface()
		
		if targeted_surface:
			var space_state := player.get_world_3d().direct_space_state
			var params := PhysicsShapeQueryParameters3D.new()
			params.collision_mask = verifier_collision_mask
			params.shape = VOXEL_SHAPE
			params.transform = Transform3D(Basis.IDENTITY, Vector3(targeted_surface.position + targeted_surface.direction))
			
			var result := space_state.intersect_shape(params, 1)
			
			if !result.is_empty():
				return
			
			player.game_world.set_voxel(targeted_surface.position + targeted_surface.direction, "STONE")
		
	
	if event.is_action_pressed("Destroy"):
		var targeted_surface : Types.VoxelSurface = get_targeted_surface()
		
		if targeted_surface:
			player.game_world.set_voxel(targeted_surface.position, "AIR")
		
