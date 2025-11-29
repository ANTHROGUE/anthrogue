extends Button
class_name ActionButton

var action: BattleAction:
	set(x):
		if x is BattleAction:
			icon = x.icon
			$CostLabel.text = str(x.ap_cost)
		else:
			icon = null
			$CostLabel.text = ""
		action = x
var user: Combatant:
	set(x):
		user_set(x)
		user = x

func user_set(_user: Combatant) -> void:
	pass
