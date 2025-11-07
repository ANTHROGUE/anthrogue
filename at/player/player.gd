extends CharacterBody3D
class_name Player



const BASE_SPEED := 8.0
const GROUND_FRICTION := 10.0
const ACCELERATION := 80.0
const BASE_JUMP_FORCE := 1.25 
const AIR_FRICTION := 10.0

## Cool and fun globally accessible variable to find the current player object :)
static var instance: Player

@onready var camera: SpringCamera = %SpringCamera


func _ready() -> void:
	instance = self
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func calculate_friction() -> float:
	if is_on_floor():
		return GROUND_FRICTION
	return GROUND_FRICTION

func calculate_jump_force() -> float:
	return BASE_JUMP_FORCE

func calculate_jump_decay() -> float:
	return calculate_jump_force() * 8.0

func calculate_run_speed() -> float:
	return BASE_SPEED
