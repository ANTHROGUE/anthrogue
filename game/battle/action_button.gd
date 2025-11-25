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
var user: Combatant
