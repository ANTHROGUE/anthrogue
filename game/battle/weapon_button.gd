extends ActionButton
class_name WeaponButton

@export var weapon: Weapon:
	set(x):
		weapon = x
		if x is Weapon:
			visible = true
			action = x.action
			x.s_weapon_charges_updated.connect(update)
			update()
		else:
			visible = false
			action = null

func update() -> void:
	$CutLabelOffense.text = "OFF:\n%s/%s" % [str(weapon.charges["Offense"].x), str(weapon.charges["Offense"].y)]
	$CutLabelDefense.text = "DEF:\n%s/%s" % [str(weapon.charges["Defense"].x), str(weapon.charges["Defense"].y)]

func user_set(_user: Combatant) -> void:
	weapon = _user.get_weapon()
