extends Node

func get_snapped_direction(dir : Vector3) -> Vector3i:
	var abs_x = abs(dir.x)
	var abs_y = abs(dir.y)
	var abs_z = abs(dir.z)
	
	if (abs_x >= abs_y) and (abs_x >= abs_z):
		return Vector3(dir.x, 0, 0).normalized()
	elif abs_y >= abs_z:
		return Vector3(0, dir.y, 0).normalized()
	else:
		return Vector3(0, 0, dir.z).normalized()

var AXIS_DIRECTIONS := {
	UP = Vector3.UP,
	DOWN = Vector3.DOWN,
	FORWARD = Vector3.FORWARD,
	BACK = Vector3.BACK,
	LEFT = Vector3.LEFT,
	RIGHT = Vector3.RIGHT
}
