extends State3D
class_name PlayerState3D


@onready var player: Player = owner
@onready var camera: SpringCamera = %SpringCamera
@onready var model: Node3D = %MeshInstance3D
@onready var last_input_dir := global_basis.z

var jumping := false
var jump_force_remaining := 0.0


func handle_standard_movement(delta: float) -> void:
	# Add the gravity.
	if not player.is_on_floor():
		player.velocity += player.get_gravity() * delta

	# Calculate movement input and align it to the camera's direction.
	var raw_input := Input.get_vector("move_left", "move_right", "move_up", "move_down", 0.4)
	# Should be projected onto the ground plane.
	var forward := camera.global_basis.z
	var right := camera.global_basis.x
	var direction := forward * raw_input.y + right * raw_input.x
	direction.y = 0.0
	direction = direction.normalized()

	if direction:
		model.rotation.y = lerp_angle(model.rotation.y, atan2(direction.x, direction.z), .3)

	var move_velocity := player.velocity.move_toward(direction * player.calculate_run_speed(), player.ACCELERATION * delta)
	player.velocity.x = move_velocity.x
	player.velocity.z = move_velocity.z

	player.move_and_slide()

func handle_camera() -> void:
	if Input.is_action_just_pressed('camera_zoom_in'):
		camera.zoom_in()
	
	if Input.is_action_just_pressed('camera_zoom_out'):
		camera.zoom_out()

func handle_jump(delta: float) -> void:
	if Input.is_action_just_pressed('jump') and player.is_on_floor():
		player.velocity.y = player.calculate_jump_force()
		jump_force_remaining = player.calculate_jump_force()
		jumping = true
	elif jumping and not Input.is_action_pressed('jump'):
		jumping = false
	elif jumping and Input.is_action_pressed('jump'):
		jump_force_remaining = move_toward(jump_force_remaining, 0.0, player.calculate_jump_decay() * delta)
		if jump_force_remaining > 0.0:
			player.velocity.y += jump_force_remaining
		else:
			jump_force_remaining = 0.0
			jumping = false
