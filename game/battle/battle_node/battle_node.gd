@tool
extends ZoneElement
class_name BattleNode

const ENEMY_DISTANCE := 5.0
const ENEMY_SPACING := 1.5

@export var enemy_count_range := Vector2i(1, 3)
@export var spawnable_enemies: Array[PackedScene] = [] ## TEMPORARY

@onready var camera: Camera3D = %BattleCamera
@onready var default_camera_angle: Transform3D = %BattleCamera.transform
@onready var animation_player: AnimationPlayer = %AnimationPlayer

var player: Player
var enemies: Array[Combatant] = []
var manager: BattleManager

var actor_positions: Dictionary[Actor3D, Vector3] = {}

func _ready() -> void:
	if not spawnable_enemies.is_empty():
		initialize_enemies()
	super()

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
		enemy.position = enemy_positions[i]

func interact() -> void:
	if not Player.instance.controller.current_state_name == 'Stopped':
		call_deferred("start_battle", Player.instance)

## TODO (WIP)
func start_battle(plyr: Player) -> void:
	if manager is BattleManager:
		return
	# Stop Player
	player = plyr
	player.request_state(&'Stopped')
	
	# Move all combatants into position
	assign_actor_positions()
	recenter_battle()
	camera.make_current()
	
	# Create our battle manager
	manager = BattleManager.new()
	manager.combatants = [player]
	manager.combatants.append_array(enemies)
	manager.battle_node = self
	add_child(manager)
	
	BattleService.s_battle_started.emit(self)

func recenter_battle() -> void:
	recenter_player()
	recenter_enemies()

func recenter_player() -> void:
	# Move player to position
	player.reparent(self)
	player.position = actor_positions.get(player)

func recenter_enemies() -> void:
	for enemy in enemies: enemy.position = actor_positions.get(enemy)

## Returns the global positions of enemies at each index
func calculate_enemy_positions(enemy_count := enemies.size()) -> Array[Vector3]:
	var center_pos := Vector3(0.0, 0.0, ENEMY_DISTANCE / 2.0)
	if enemy_count % 2 == 0:
		center_pos.x -= ENEMY_SPACING / 2.0
	center_pos.x -= ENEMY_SPACING * (maxi(enemy_count - 2, 0))
	var enemy_positions: Array[Vector3] = []
	for i in enemy_count:
		enemy_positions.append(center_pos)
		center_pos.x += ENEMY_SPACING
	return enemy_positions

func calculate_player_position() -> Vector3:
	return Vector3(0, 0, -ENEMY_DISTANCE / 2.0)

func assign_actor_positions() -> void:
	actor_positions.set(player, calculate_player_position())
	var enemy_positions := calculate_enemy_positions()
	for enemy in enemies:
		actor_positions.set(enemy, enemy_positions[enemies.find(enemy)])
