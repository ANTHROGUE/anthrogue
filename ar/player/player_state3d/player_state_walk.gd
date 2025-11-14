extends PlayerState3D


func _enter(_prev: State3D):
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	handle_standard_movement(delta)
	handle_jump(delta)
	handle_camera()
