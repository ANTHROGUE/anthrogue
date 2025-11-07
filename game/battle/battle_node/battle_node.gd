extends Area3D
class_name BattleNode


func _ready() -> void:
	set_collision_layer_value(Globals.COLLISION_LAYER_INTERACT, true)

func on_body_entered(body: Node3D) -> void:
	if body is Player:
		on_player_entered(body)

func on_player_entered(player: Player) -> void:
	start_battle(player)

## TODO
func start_battle(player: Player) -> void:
	pass
