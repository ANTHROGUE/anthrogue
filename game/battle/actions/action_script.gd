extends Node
class_name ActionScript

signal s_action_end
signal s_action_impact

## Relevant combatants
var source: Combatant
var target: Combatant
## Other variables
var manager: BattleManager
var battle_node: BattleNode

## Override to script your battle movie
func action() -> void:
	impact()
	end_action()
	pass

func end_action() -> void:
	print("End of Action %s" % name)
	s_action_end.emit()

func impact() -> void:
	print("Impact of Action %s" % name)
	s_action_impact.emit()
