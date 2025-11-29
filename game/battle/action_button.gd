extends Button
class_name ActionButton

var action: BattleAction:
	set(x):
		if x is BattleAction:
			icon = x.icon
		else:
			icon = null
		action_set(x)
		action = x
var user: Combatant:
	set(x):
		user_set(x)
		user = x

func user_set(_user: Combatant) -> void:
	pass

func action_set(_action: BattleAction) -> void:
	if _action is BattleAction:
		$CostLabel.text = str(_action.ap_cost)
	else: $CostLabel.text = ""
