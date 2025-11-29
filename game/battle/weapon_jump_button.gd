extends WeaponButton
class_name WeaponJumpButton

var cut_manager: CutManager:
	set(x):
		cut_manager.s_cut_state_changed.connect(change_to_cut_state)

var state: String

func update() -> void:
	super()
	disabled = !weapon.has_enough_charges(state)

func change_to_cut_state(_state: CutManager.CUT_STATE) -> void:
	reset_connections()
	
	state = CutManager.CUT_STATE.find_key(_state)
	var jump: BattleAction
	
	if state not in weapon.jumps.keys():
		visible = false
		return
		
	jump = weapon.jumps[state]
	visible = true
	disabled = !weapon.has_enough_charges(state)
	
	if jump is BattleAction:
		$Label.text = jump.name
		pressed.connect(cut_manager.attempt_cut_input.bind(user))

func reset_connections() -> void:
	for connection in pressed.get_connections():
		pressed.disconnect(connection['callable'])
