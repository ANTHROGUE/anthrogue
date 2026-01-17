extends Item
class_name Weapon

@export var action: BattleAction

@export var jumps: Dictionary[String, BattleAction] = {
	"Offense": null,
	"Defense": null
}
@export var charges: Dictionary[String, Vector2i] = {
	"Offense": Vector2i(3, 3),
	"Defense": Vector2i(3, 3)
}

@export var charge_regen := 1

signal s_weapon_charges_updated()

func apply_item(combatant: Combatant, object: Node3D = null) -> void:
	super(combatant, object)

func spend_charge(key: String) -> bool:
	if key not in charges.keys():
		printerr("Weapon: Key %s not in charge types" % key)
		return false
	
	if has_enough_charges(key):
		charges[key].x -= charges[key].y
		s_weapon_charges_updated.emit()
		return true
	
	print("Weapon: Not enough charges for %s Jump" % key)
	return false

func regen_charges() -> void:
	for key in charges.keys():
		gain_charge(charge_regen, key, true)

func gain_charge(amount: int, _key = null, use_limit := false) -> void:
	var key = charges.keys().pick_random()
	if _key is String:
		if _key in charges.keys():
			key = _key
	
	if use_limit and charges[key].x <= charges[key].y:
		charges[key].x = clampi(charges[key].x + amount, 0, charges[key].y)
	else: charges[key].x += amount
	
	s_weapon_charges_updated.emit()

func has_enough_charges(key: String) -> bool:
	if key not in charges:
		return false
	return charges[key].x >= charges[key].y
