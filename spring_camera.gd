extends SpringArm3D
class_name SpringCamera

const RECENTER_SPD := 15.0
const RECENTER_ACCEL := 10.0
const RECENTER_TIME_LIMIT := 0.25
const SENSITIVITY = .005
const ZOOM_DIST := 1.0
const ZOOM_BOUNDS := Vector2(3.0, 6.0)
const DEFAULT_ZOOM := 4.0

@export var y_offset: float = 1.061

@onready var player: Player = NodeGlobals.get_ancestor_of_type(self, Player)
@onready var camera: Camera3D = %Camera

var recentering := false
var recenter_time := 0.0
var recenter_spd := RECENTER_SPD
var fov: float:
	get: return camera.fov
	set(x): camera.fov = x
var zoom_tween: Tween
var zoom_amt: float:
	set(x):
		x = clampf(x, ZOOM_BOUNDS.x, ZOOM_BOUNDS.y)
		zoom_tween = create_tween().set_trans(Tween.TRANS_QUAD)
		zoom_tween.tween_property(self, 'spring_length', x, 0.2)
		zoom_tween.finished.connect(zoom_tween.kill)
	get:
		return spring_length


func _ready() -> void:
	spring_length = DEFAULT_ZOOM

func _unhandled_input(event) -> void:
	# Orbital Camera
	if event is InputEventMouseMotion: #and player.controller.current_state.accepts_interaction() and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		#if ((not player.control_style and Input.is_action_pressed('pull_camera'))
				#or (player.control_style and not recentering)):
			pull_step(event)

func _physics_process(delta: float) -> void:
	#global_position = player.get_global_transform_interpolated().origin + Vector3(0, y_offset, 0)
	
	if recentering:
		recenter_step(delta)

func make_current() -> void:
	camera.make_current()

func pull_step(event: InputEventMouseMotion) -> void:
	rotate_y(-event.relative.x * SENSITIVITY)
	rotation.x -= event.relative.y * SENSITIVITY 
	rotation.x = clamp(rotation.x, deg_to_rad(-89), deg_to_rad(89))

func recenter_step(delta: float) -> void:
	var prev_rot := rotation
	#rotation_degrees = Vector3(0.0, player.toon.rotation_degrees.y + 180.0, 0.0)
	var goal_quat := quaternion
	rotation = prev_rot
	quaternion = quaternion.slerp(goal_quat, recenter_spd * delta) 
	if quaternion.is_equal_approx(goal_quat) or recenter_time > RECENTER_TIME_LIMIT:
		recentering = false
		recenter_time = 0.0
		recenter_spd = RECENTER_SPD
	else:
		recenter_time += delta
		recenter_spd += delta * RECENTER_ACCEL

func is_centered() -> bool:
	return rotation.is_equal_approx(Vector3(0, player.toon.rotation.y - PI, 0))

func zoom_in() -> void:
	zoom_amt -= ZOOM_DIST

func zoom_out() -> void:
	zoom_amt += ZOOM_DIST
