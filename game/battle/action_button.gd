extends Button
class_name ActionButton

var action: BattleAction:
	set(x):
		if x is BattleAction:
			icon = x.icon
		else:
			icon = null
		action = x
var user: Combatant
