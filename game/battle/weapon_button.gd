extends ActionButton
class_name WeaponButton

@export var weapon: Weapon:
	set(x):
		if x is Weapon:
			visible = true
			action = x.action
		else:
			visible = false
			action = null
		weapon = x
