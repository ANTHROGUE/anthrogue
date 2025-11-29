extends Node
class_name CutManager

var timeline: BattleTimeline:
	set(x):
		if x is BattleTimeline:
			x.s_action_script_started.connect(func(s: ActionScript): if cut_state != CUT_STATE.Locked: current_action_script = s)
			x.s_queue_finished.connect(clear_cut_inputs)
		timeline = x
var manager: BattleManager

class CutAction:
	var user: Combatant
	var target: Combatant
	var action: BattleAction
	var cut_type: CUT_STATE
	func as_queued_action() -> BattleTimeline.QueuedAction:
		var _out = BattleTimeline.QueuedAction.new()
		for key in ['user', 'target', 'action']:
			_out[key] = self[key]
		return _out

enum CUT_STATE {
	None,
	Offense,
	Defense,
	Command,
	Locked
}

var cut_state := CUT_STATE.None:
	set(x):
		print("Entering Cut State %s" % CUT_STATE.find_key(x))
		s_cut_state_changed.emit(x)
		cut_state = x
		
signal s_cut_input_received(user: Combatant)
signal s_cut_state_changed(state: CUT_STATE)

var cut_input_mappings: Dictionary[String, Combatant]

var impact_count := 0
var current_action_script: ActionScript:
	set(x):
		impact_count = 0
		if x is ActionScript:
			x.s_action_impact.connect(func(): impact_count += 1)
			x.s_action_interval_started.connect(func(ival: ActiveInterval): active_interval = ival)
		else:
			active_interval = null
		current_action_script = x
var active_interval: ActiveInterval

func _ready() -> void:
	# ?????
	timeline = get_parent()
	manager = timeline.get_parent()
	manager.s_turn_confirmed.connect(accept_cut_inputs)
	
	BattleService.cut_manager = self

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
	match cut_state:
		CUT_STATE.None, CUT_STATE.Command, CUT_STATE.Locked:
			print("CUT-IN: Attempted during state %s, cancelling" % CUT_STATE.find_key(cut_state))
			return
	
	var weapon = user.inventory.weapon
	if weapon is not Weapon:
		return
	
	var key: String = CUT_STATE.find_key(cut_state)
	
	if !weapon.spend_charge(key):
		return
	
	var cut_action := CutAction.new()
	cut_action.user = user
	cut_action.cut_type = cut_state
	cut_action.action = weapon.jumps[key]
	if cut_action.action is not BattleAction:
		printerr("CUT-IN: Cut-In Action not found")
		return
	
	# TODO: Refactor this into teams
	if current_action_script.target == cut_action.user && !cut_action.cut_type == CUT_STATE.Defense:
		cut_action.target = current_action_script.user
	else: cut_action.target = current_action_script.target
	execute_cut_action(cut_action)

func execute_cut_action(cut_action: CutAction) -> void:
	var previous_cs := cut_state
	print("CUT-IN: Performing %s now | %s -> %s" % [cut_action.action.name, cut_action.user, cut_action.target])
	if active_interval is not ActiveInterval:
		printerr("CutManager: Active Interval not set")
		return
	active_interval.pause()
	cut_state = CUT_STATE.Locked
	await timeline.run_action(cut_action.as_queued_action())
	active_interval.play()
	cut_state = previous_cs
