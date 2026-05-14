class_name Player
extends CharacterBody3D

var GRAVITY : float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta):
	velocity.y -= GRAVITY * delta
	
	move_and_slide()
