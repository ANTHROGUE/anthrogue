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
	visible = state in weapon.jumps.keys()

func change_to_cut_state(_state: CutManager.CUT_STATE) -> void:
	reset_connections()
	
	state = CutManager.CUT_STATE.find_key(_state)
	var jump: BattleAction
	
	if state not in weapon.jumps.keys():
		hide()
		return
		
	jump = weapon.jumps[state]
	show()
	
	if jump is BattleAction:
		$Label.text = jump.name
		pressed.connect(cut_manager.attempt_cut_input.bind(user))
	
	update()

func reset_connections() -> void:
	for connection in pressed.get_connections():
		pressed.disconnect(connection['callable'])
