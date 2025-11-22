extends Node
class_name BattleManager


const BATTLE_UI := preload('res://game/battle/battle_ui/battle_ui.tscn')

class QueuedAction:
	var user: Combatant
	var target: Combatant
	var alt_targets: Array[Combatant] = []
	var action: BattleAction

var combatants: Array[Combatant] = []
var battle_ui: Control
var action_queue: Array[QueuedAction] = []

## BANGRS - Moves calculated using AGI, may be varied
## v2i - (queued, max)
var move_counts: Dictionary[Combatant, Vector2i] = {}

var player_moves_queued := 0

signal s_turn_confirmed()
signal s_new_round()

func _ready() -> void:
	battle_ui = BATTLE_UI.instantiate()
	battle_ui.s_move_queued.connect(queue_action)
	battle_ui.s_move_selected.connect(select_action)
	add_child(battle_ui)
	
	s_turn_confirmed.connect(on_turn_confirmed)
	#s_new_round.connect(on_new_round)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	s_new_round.emit()

func on_turn_confirmed() -> void:
	#append_enemy_moves()
	if !(action_queue.size() > 0):
		print("Action Queue size invalid")
		return
	begin_round()

func queue_action(action: BattleAction, user: Combatant = null, target: Combatant = null, alt_targets: Array[Combatant] = [], timing: int = -1, loose: bool = false) -> void:
	var space: int
	# Strict pre-calculated action queue size
	if timing > -1 && timing < action_queue.size():
		if action_queue[timing] is QueuedAction:
			if !loose:
				print("Overwriting %s in move timeline" % action_queue[timing].name)
				space = timing
			## Loose: If timing is taken, find the closest next open space (forward first) 
			else:
				var _f := 0.0
				for i in action_queue.size() - 1:
					var check: int
					var next_space_valid := func lambda(x: int) -> bool:
						if x is not int:
							return false
						return x > -1 && x < action_queue.size()
					while !next_space_valid.call(check):
						_f = -(_f - 0.5)
						check = timing + ceili(_f)
					if action_queue[check] is QueuedAction:
						continue
					space = timing + i
					break
	else:
		# Occupy the next open space
		for i in action_queue.size():
			if action_queue[i] is QueuedAction:
				continue
			space = i
			break
			
	if space is int:
		var queued_action := QueuedAction.new()
		queued_action.user = user
		queued_action.target = target
		queued_action.alt_targets = alt_targets
		queued_action.action = action
		action_queue[space] = queued_action
	else:
		printerr("Timeline does not have space for Action %s" % action)
		return
		
	if !move_counts[user].x < move_counts[user].y:
		printerr("Attempted to queue action %s from %s without an available move" % [action.name, user.name])
		return 
	move_counts[user].x += 1
	
	var __p := "Action Queued: %s from %s" % [action.name, user.name]
	if target is Combatant:
		__p += " targeting %s" % target.name
	print(__p)
	
	user.stats.ap -= action.ap_cost

func append_enemy_moves() -> void:
	for combatant in combatants:
		if combatant is Enemy:
			queue_action(combatant.get_action(), combatant, Player.instance, [Player.instance], randi_range(1, action_queue.size()), true)

func begin_action_queue() -> void:
	action_queue.clear()
	move_counts.clear()
	var move_total := 0
	for combatant in combatants:
		var move_count = combatant.stats.calculate_moves()
		move_counts.set(combatant, Vector2i(0, move_count))
		move_total += move_count
	action_queue.resize(move_total)
	## BANGRS: enemy moves in timeline!
	append_enemy_moves()

func begin_round() -> void:
	for action in action_queue:
		if action is QueuedAction:
			await run_action(action) 
		else:
			print("Next action is null, skipping")
	for combatant: Combatant in combatants:
		combatant.stats.ap = clamp(combatant.stats.ap + combatant.stats.ap_regen, 0, combatant.stats.max_ap)
	begin_action_queue()
	s_new_round.emit()
	
#func on_new_round() -> void:
	

func run_action(action: QueuedAction) -> void:
	var battle_action: BattleAction = action.action
	var action_node := Node.new()
	if battle_action.action_script:
		action_node.set_script(battle_action.action_script)
		for combatant in ['user', 'target', 'alt_targets']:
			if action[combatant] != null:
				action_node[combatant] = action[combatant]
		action_node.manager = self
		add_child(action_node)
		if action_node is ActionScript:
			action_node.action()
			await action_node.s_action_end
	action_node.queue_free()

func select_action(action: BattleAction, user: Combatant) -> void:
	print("Selected %s from %s" % [action, user])
	pass
