extends Node
class_name BattleManager


const BATTLE_UI := preload("uid://dr7ndutcapucw")
const BATTLE_TIMELINE := preload("uid://hdlhael228mk")

var battle_ui: BattleUI:
	set(x):
		x.s_move_selected.connect(select_action)
		if x not in get_children():
			add_child(x)
		battle_ui = x
		
var timeline: BattleTimeline:
	set(x):
		s_turn_confirmed.connect(x.on_turn_confirmed)
		if x not in get_children():
			add_child(x)
		timeline = x

var battle_node: BattleNode

var current_round := 0

class QueuedAction:
	var user: Combatant
	var target: Combatant
	var alt_targets: Array[Combatant] = []
	var action: BattleAction

var combatants: Array[Combatant] = []



## BANGRS - Moves calculated using AGI, may be varied
## v2i - (queued, max)
var move_counts: Dictionary[Combatant, Vector2i] = {}
var move_total := 0

var player_moves_queued := 0

signal s_turn_confirmed()
signal s_new_round()
signal s_timeline_ready()
signal s_battle_ended()

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	timeline = BATTLE_TIMELINE.instantiate()
	battle_ui = BATTLE_UI.instantiate()
	battle_ui.s_move_queued.connect(timeline.queue_action)
	timeline.s_queue_changed.connect(battle_ui.refresh_stats)
	
	prepare_queue()
	
	begin_round()

func append_enemy_moves() -> void:
	for combatant in combatants:
		if combatant is Enemy:
			#queue_action(combatant.get_action(), combatant, Player.instance, [Player.instance], 1, true)
			timeline.queue_action(combatant.get_action(), combatant, Player.instance, [Player.instance], randi_range(1, move_total - 1), true, false)
			#timeline.queue_action(combatant.get_action(), combatant, Player.instance, [Player.instance], 5, true)

func prepare_queue() -> void:
	move_counts.clear()
	move_total = 0
	for combatant in combatants:
		var move_count = combatant.stats.calculate_moves()
		move_counts.set(combatant, Vector2i(0, move_count))
		move_total += move_count
	timeline.reset_queue()
	

func begin_round() -> void:
	current_round += 1
	for combatant: Combatant in combatants:
		combatant.stats.ap = clamp(combatant.stats.ap + combatant.stats.ap_regen, 0, combatant.stats.max_ap)
		var weapon = combatant.get_weapon()
		if weapon is Weapon:
			weapon.regen_charges()
	prepare_queue()
	## BANGRS: enemy moves in timeline!
	append_enemy_moves()
	s_new_round.emit()

func select_action(action: BattleAction, user: Combatant) -> void:
	print("Selected %s from %s" % [action, user])
	pass

func validate_combatants() -> void:
	var _combatants: Array[Combatant] = []
	for combatant: Combatant in combatants:
		if is_instance_valid(combatant):
			_combatants.append(combatant)
			var _c := false
			for connection in combatant.stats.s_hp_changed.get_connections():
				_c = _c or check_pulses == connection['callable']
			if !_c:
				combatant.stats.s_hp_changed.connect(check_pulses)
	combatants = _combatants
 
## TODO: Integrate with BattleTimeline
func end_round() -> void:
	validate_combatants()
	if get_enemies().is_empty():
		end_battle()
		return
	else:
		begin_round()

func end_battle() -> void:
	#Player.instance.reparent(get_tree().current_scene)
	Player.instance.request_state('Walk')
	battle_node.queue_free()
	SceneLoader.add_persistent_node(Player.instance)
	s_battle_ended.emit()

func check_pulses(targets: Array[Combatant]) -> void:
	for target in targets:
		if target.stats.hp <= 0:
			await remove_combatant(target)

func get_enemies() -> Array[Enemy]:
	var enemies: Array[Enemy] = []
	for combatant in combatants:
		if combatant is Enemy:
			enemies.append(combatant)
	return enemies

func remove_combatant(who: Combatant) -> void:
	combatants.erase(who)
	timeline.scrub_battle()
	@warning_ignore("redundant_await")
	await who.lose()
	who.queue_free()
