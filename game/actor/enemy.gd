extends Combatant
class_name Enemy


## Battle Actions this enemy uses
@export var actions: Array[BattleAction] = []



func get_action() -> BattleAction:
	return actions.pick_random()
