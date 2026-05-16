## Main player controller
class_name Player
extends CharacterBody3D

@export var game_world : GameWorld

var gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var movement_speed : float = 5.0
@export var jump_velocity : float = 7.0

@export var god_velocity : float = 60.0
@export var god_mode := false
var god_goal = Vector3.ZERO

@onready var camera_controller : CameraController = $CameraController

var control_enabled : bool = true

func _ready():
	set_control_enabled(control_enabled)

func _process(_delta):
	if control_enabled:
		rotation_degrees.y = camera_controller.yaw
		camera_controller.rotation_degrees.x = camera_controller.pitch

func _physics_process(delta):
	if god_mode:
		handle_god_mode(delta)
		return
	
	# Plane movement
	handle_movement_velocity(delta)
	
	# Handle gravity, jump
	handle_vertical_velocity(delta)
	
	move_and_slide()

## Handle XZ plane movement
func handle_movement_velocity(_delta):
	var input_z = Input.get_axis("Forwards", "Backwards")
	var input_x = Input.get_axis("Left", "Right")
	
	if not control_enabled:
		input_z = 0
		input_x = 0
	
	var relative_movement_vel = Vector3(input_x, 0, input_z).normalized() * movement_speed
	var movement_velocity = global_transform.basis * relative_movement_vel
	
	velocity.x = movement_velocity.x
	velocity.z = movement_velocity.z

## Handle Y axis movement
func handle_vertical_velocity(delta):
	# Gravity/Floor
	if is_on_floor():
		# If on ground, clamp velocity to be at or above 0
		velocity.y = max(0, velocity.y)
	else:
		# If on air, apply gravity
		velocity.y -= gravity * delta
	
	if Input.is_action_pressed("Jump") and control_enabled:
		on_spacebar_pressed()

func _input(_event):
	if Input.is_action_just_pressed("Menu"):
		set_control_enabled(!control_enabled)
	
	if Input.is_action_just_pressed("Debug1"):
		god_goal = position
		god_mode = !god_mode

func on_spacebar_pressed():
	if can_jump():
		velocity.y += jump_velocity

func can_jump() -> bool:
	if !is_on_floor():
		return false
	
	return true

func set_control_enabled(enabled : bool):
	control_enabled = enabled
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if enabled else Input.MOUSE_MODE_VISIBLE
	
	print("Control enabled" if enabled else "Control disabled")

func handle_god_mode(delta):
	var input_x = Input.get_axis("Left", "Right")
	var input_y = Input.get_axis("Down", "Jump")
	var input_z = Input.get_axis("Forwards", "Backwards")
	
	god_goal += global_transform.basis * Vector3(
		input_x,
		input_y,
		input_z
	) * god_velocity * delta
	
	position = position.lerp(god_goal, 10 * delta)
	
