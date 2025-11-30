extends Node
class_name ActionScript

signal s_action_interval_started(active_interval: ActiveInterval)
signal s_action_end
signal s_action_impact
signal s_cut_state_entered(state: CutManager.CUT_STATE, user: Combatant)

## Relevant combatants
var user: Combatant
var target: Combatant:
	set(x):
		if x.stats is BattleStats: x.stats.s_hp_changed.connect(validate_target)
		target = x
var alt_targets: Array[Combatant]
## Other variables
var manager: BattleManager

var values: Array = []
var impact_count := 0

var ival_path: String
var ival_node: IntervalNode
var ival: Interval
var active_ival: ActiveInterval

## Override to script your battle movie
func action() -> void:
	if !is_instance_valid(target): return
	
	print("Action: %s" % name)
	ival_node = load(ival_path).instantiate()
	if ival_node is IntervalNode:
		assign_ival()
		active_ival = ival.start(self, true)
		s_action_interval_started.emit(active_ival)
		await active_ival.finished
		end_action()
	else:
		impact()
		end_action()

func end_action() -> void:
	print("End of Action %s" % name)
	cutstate("None")
	s_action_end.emit()

func impact() -> void:
	print("Impact of Action %s" % name)
	impact_count += 1
	s_action_impact.emit()
	
func cutstate(state: String) -> void:
	if state not in CutManager.CUT_STATE.keys():
		printerr("Cutstate %s not in CutManager" % state)
		return
	s_cut_state_entered.emit(CutManager.CUT_STATE[state], user)

func assign_ival() -> void:
	add_child(ival_node)
	for combatant in ['user', 'target', 'alt_targets']:
		for sub_ival in get_tree().get_nodes_in_group("ival_battle_" + combatant):
			if self[combatant] == null:
				printerr("ERROR: Combatant %s not in ActionScript %s" % [combatant, self])
				break
			sub_ival.node = self[combatant]
	for f in ['impact', 'cutstate']:
		for sub_ival: FuncNode in get_tree().get_nodes_in_group("ival_battle_" + f):
			sub_ival.node = self
			sub_ival.function = f
	ival = ival_node.as_interval()
	ival_node.queue_free()

func validate_target() -> void:
	if target.stats.hp <= 0:
		end_action()
		if active_ival is ActiveInterval and impact_count <= 0:
			active_ival.stop()
