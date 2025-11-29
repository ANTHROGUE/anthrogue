extends WeaponButton
class_name WeaponJumpButton

var cut_manager: CutManager:
	set(x):
		x.s_cut_state_changed.connect(change_to_cut_state)
		cut_manager = x

var state: String

func _ready() -> void:
	cut_manager = await BattleService.get_cut_manager()

func update() -> void:
	super()
	disabled = !weapon.has_enough_charges(state)
	if state in weapon.jumps.keys() and !disabled:
		modulate = Color(1.0, 1.0, 1.0, 1.0)
	else: modulate = Color(1.0, 1.0, 1.0, 0.498)

func change_to_cut_state(_state: CutManager.CUT_STATE) -> void:
	reset_connections()
	
	state = CutManager.CUT_STATE.find_key(_state)
	var jump: BattleAction
	update()
	
	if state not in weapon.jumps.keys():
		$Label.text = ""
		return
		
	jump = weapon.jumps[state]
	
	action = jump
	
	if jump is BattleAction:
		$Label.text = jump.name
		pressed.connect(cut_manager.attempt_cut_input.bind(user))

func reset_connections() -> void:
	for connection in pressed.get_connections():
		pressed.disconnect(connection['callable'])

func weapon_set(_weapon: Weapon) -> void:
	pass
