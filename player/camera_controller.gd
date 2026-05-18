class_name CameraController
extends Camera3D

var yaw : float = 0
var pitch : float = 0

@export var sensitivity : float = 0.3
@export var pitch_limit : float = 85
@export var enabled : bool = true

func _ready():
	pass # Replace with function body.

func _input(event):
	if not enabled:
		return
	
	if event is InputEventMouseMotion:
		var velocity = event.screen_relative
		
		yaw -= velocity.x * sensitivity
		pitch -= velocity.y * sensitivity
		
		pitch = clamp(pitch, -pitch_limit, pitch_limit)
