@tool
extends Area3D
class_name BattleNode


const ENEMY_DISTANCE := 5.0
const ENEMY_SPACING := 1.5

@export var enemy_count_range := Vector2i(1, 3)
@export var spawnable_enemies: Array[PackedScene] = [] ## TEMPORARY

@onready var camera: Camera3D = %BattleCamera
@onready var default_camera_angle: Transform3D = %BattleCamera.transform

var player: Player
var enemies: Array[Combatant] = []
var manager: BattleManager

func _ready() -> void:
	set_collision_mask_value(Globals.COLLISION_LAYER_INTERACT, true)
	if not body_entered.is_connected(on_body_entered):
		body_entered.connect(on_body_entered)
	if not spawnable_enemies.is_empty():
		initialize_enemies()
	%Pointer.queue_free()

func initialize_enemies() -> void:
	# Remove existing enemies
	for enemy in enemies:
		enemy.queue_free()
	enemies.clear()
	
	# Spawn in our enemies
	var enemy_count := randi_range(enemy_count_range.x, enemy_count_range.y)
	var enemy_positions := calculate_enemy_positions(enemy_count)
	for i in enemy_count:
		var enemy: Combatant = spawnable_enemies.pick_random().instantiate()
		enemies.append(enemy)
		add_child(enemy)
		enemy.global_position = enemy_positions[i]

func on_body_entered(body: Node3D) -> void:
	if body is Player:
		on_player_entered(body)

func on_player_entered(plyr: Player) -> void:
	call_deferred("start_battle", plyr)

## TODO (WIP)
func start_battle(plyr: Player) -> void:
	if manager is BattleManager:
		return
	# Stop Player
	player = plyr
	player.request_state(&'Stopped')
	
	# Move all combatants into position
	recenter_battle()
	camera.make_current()
	
	# Create our battle manager
	manager = BattleManager.new()
	manager.combatants = [player]
	manager.combatants.append_array(enemies)
	add_child(manager)

func recenter_battle() -> void:
	recenter_player()
	recenter_enemies()

func recenter_player() -> void:
	# Move player to position
	player.reparent(self)
	player.global_position = calculate_player_position()

func recenter_enemies() -> void:
	# Slap our enemies into position
	var enemy_positions := calculate_enemy_positions()
	for enemy in enemies: enemy.global_position = enemy_positions[enemies.find(enemy)]

## Returns the global positions of enemies at each index
func calculate_enemy_positions(enemy_count := enemies.size()) -> Array[Vector3]:
	var center_pos := Vector3(0.0, 0.0, ENEMY_DISTANCE / 2.0)
	if enemy_count % 2 == 0:
		center_pos.x -= ENEMY_SPACING / 2.0
	center_pos.x -= ENEMY_SPACING * (maxi(enemy_count - 2, 0))
	var enemy_positions: Array[Vector3] = []
	for i in enemy_count:
		enemy_positions.append(to_global(center_pos))
		center_pos.x += ENEMY_SPACING
	return enemy_positions

func calculate_player_position() -> Vector3:
	return to_global(Vector3(0, 0, -ENEMY_DISTANCE / 2.0))
