extends PlayerState3D



func _physics_process(delta: float) -> void:
	handle_standard_movement(delta)
	handle_jump(delta)
	handle_camera()
