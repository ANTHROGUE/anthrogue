extends Node
class_name BattleManager


const BATTLE_UI := preload('res://game/battle/battle_ui/battle_ui.tscn')

var current_round := 0

class QueuedAction:
	var user: Combatant
	var target: Combatant
	var alt_targets: Array[Combatant] = []
	var action: BattleAction

var combatants: Array[Combatant] = []
var battle_ui: BattleUI
var timeline: BattleTimeline
var action_queue: Array[QueuedAction] = []

## BANGRS - Moves calculated using AGI, may be varied
## v2i - (queued, max)
var move_counts: Dictionary[Combatant, Vector2i] = {}
var move_total := 0

var player_moves_queued := 0

signal s_turn_confirmed()
signal s_new_round()
signal s_timeline_ready()

func _ready() -> void:
	timeline = BattleTimeline.new()
	add_child(timeline)
	
	battle_ui = BATTLE_UI.instantiate()
	battle_ui.s_move_queued.connect(timeline.queue_action)
	battle_ui.s_move_selected.connect(select_action)
	add_child(battle_ui)
	
	s_turn_confirmed.connect(timeline.on_turn_confirmed)
	#s_new_round.connect(on_new_round)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	prepare_queue()

func append_enemy_moves() -> void:
	for combatant in combatants:
		if combatant is Enemy:
			#queue_action(combatant.get_action(), combatant, Player.instance, [Player.instance], 1, true)
			timeline.queue_action(combatant.get_action(), combatant, Player.instance, [Player.instance], randi_range(1, move_total), true)

func prepare_queue() -> void:
	move_counts.clear()
	move_total = 0
	for combatant in combatants:
		var move_count = combatant.stats.calculate_moves()
		move_counts.set(combatant, Vector2i(0, move_count))
		move_total += move_count
	timeline.reset_queue()
	## BANGRS: enemy moves in timeline!
	append_enemy_moves()
	s_new_round.emit()

func begin_round() -> void:
	current_round += 1
	for combatant: Combatant in combatants:
		combatant.stats.ap = clamp(combatant.stats.ap + combatant.stats.ap_regen, 0, combatant.stats.max_ap)
	prepare_queue()

func select_action(action: BattleAction, user: Combatant) -> void:
	print("Selected %s from %s" % [action, user])
	pass
