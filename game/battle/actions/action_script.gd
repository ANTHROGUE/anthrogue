extends Node
class_name ActionScript


var user: Combatant
var targets: Array[Combatant] = []
var manager: BattleManager
var battle_node: BattleNode

## Override to script your battle movie
func action() -> void:
	pass
