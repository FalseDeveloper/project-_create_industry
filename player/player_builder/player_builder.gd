class_name PlayerBuilder
extends Node

@export var build_range = 100
@export var player : Player

@onready var debug_sphere = $DebugSphere
@onready var aimer = $Aimer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(_delta):
	var targeted_surface := get_targeted_surface()
	
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
	
	if result:
		debug_sphere.global_position = result.position
		
		var direction := Utils.get_snapped_direction(result.normal)
		var targeted_position : Vector3 = result.position - (result.normal * 0.01)
		var targeted_voxel := player.game_world.world_to_grid_space(targeted_position)
		
		targeted_surface.position = targeted_voxel
		targeted_surface.direction = direction
	
	return targeted_surface

func _input(event):	
	if event.is_action_pressed("Place"):
		var targeted_surface : Types.VoxelSurface = get_targeted_surface()
		
		player.game_world.set_voxel(targeted_surface.position + targeted_surface.direction)
