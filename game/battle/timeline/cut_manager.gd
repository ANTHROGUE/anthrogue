extends Node
class_name CutManager

var timeline: BattleTimeline:
	set(x):
		if x is BattleTimeline:
			pass
		timeline = x
var manager: BattleManager

enum CUT_STATE {
	None,
	Offense,
	Defense,
	Command,
}

var cut_state := CUT_STATE.None:
	set(x):
		print("Entering Cut State %s" % x)
		cut_state = x
signal s_cut_input_received(user: Combatant)

var cut_input_mappings: Dictionary[String, Combatant]

func _ready() -> void:
	# ?????
	timeline = get_parent()
	manager = timeline.get_parent()
	manager.s_turn_confirmed.connect(accept_cut_inputs)

func _process(delta: float) -> void:
	for input in cut_input_mappings.keys():
		if Input.is_action_just_pressed(input): s_cut_input_received.emit(cut_input_mappings[input])

func accept_cut_inputs() -> void:
	cut_input_mappings = {
		"cut_in_01": Player.instance
	}
	s_cut_input_received.connect(attempt_cut_input)
	#for combatant in manager.combatants:
		#attempt_cut_input.bind(combatant)
		#pass

func clear_cut_inputs() -> void:
	cut_input_mappings.clear()
	s_cut_input_received.disconnect(attempt_cut_input)

func attempt_cut_input(user: Combatant) -> void:
	var weapon = user.inventory.weapon
	if weapon is not Weapon:
		return
	
	var action: BattleAction
	var cd := 0
	match cut_state:
		CUT_STATE.Offense:
			cd = weapon.offense_cd_timer
			action = weapon.offense_cut
		CUT_STATE.Defense:
			cd = weapon.defense_cd_timer
			action = weapon.defense_cut
	if action is not BattleAction:
		printerr("CUT-IN: Cut-In Action not found")
	if cd > 0:
		print("CUT-IN: Attempted %s Cut-In on CD: %d" % [cut_state, cd])
		return
	print("CUT-IN: Performing %s now" % action.name)
