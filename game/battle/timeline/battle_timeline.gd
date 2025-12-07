extends Node
class_name BattleTimeline

class QueuedAction:
	var user: Combatant
	var target: Combatant
	var alt_targets: Array[Combatant] = []
	var action: BattleAction

var queue: Array[QueuedAction] = []
var current_action: QueuedAction = null

signal s_queue_changed()
signal s_queue_finished()
signal s_action_script_started(script: ActionScript)

var manager: BattleManager:
	set(x):
		if x is BattleManager:
			s_queue_finished.connect(x.end_round)
			x.s_timeline_ready.emit()
		manager = x
		
@onready var cut_manager: CutManager = $CutManager

func _ready() -> void:
	manager = get_parent()
	
func queue_action(action: BattleAction, user: Combatant = null, target: Combatant = null, alt_targets: Array[Combatant] = [], timing: int = -1, loose: bool = false) -> void:
	var space: int = -1
	# Strict pre-calculated action queue size
	if timing > -1 && timing < queue.size():
		if !queue[timing] is QueuedAction:
			space = timing
		else:
			if !loose:
				## TODO: Cancel move function
				print("Overwriting %s in move timeline" % queue[timing].name)
				space = timing
			## Loose: If timing is taken, find the closest next open space (forward first) 
			else:
				var verify = func lambda(x: int) -> bool: return x in range(queue.size())
				var distance := 0
				while !space > -1:
					var check = -1
					distance += 1
					for direction in [1, -1]:
						var pre_check = timing + (distance * direction)
						if verify.call(pre_check):
							check = pre_check
						if check == -1 or queue[check] is QueuedAction:
							continue
						else:
							space = check
							break
					if check == -1:
						break
	else:
		# Occupy the next open space
		for i in queue.size():
			if queue[i] is QueuedAction:
				continue
			space = i
			break
			
	if space > -1 and space < queue.size():
		var queued_action := QueuedAction.new()
		queued_action.user = user
		queued_action.target = target
		queued_action.alt_targets = alt_targets
		queued_action.action = action
		queue[space] = queued_action
	else:
		printerr("Timeline does not have space for Action %s" % action)
		return
		
	if !manager.move_counts[user].x < manager.move_counts[user].y:
		printerr("Attempted to queue action %s from %s without an available move" % [action.name, user.name])
		return 
	manager.move_counts[user].x += 1
	
	var __p := "Action Queued: %s from %s" % [action.name, user.name]
	if target is Combatant:
		__p += " targeting %s" % target.name
	if timing > -1:
		__p += " with timing: %d" % timing
		if space != timing:
			__p += " (Moved to space: %d)" % space
	print(__p)
	
	user.stats.ap -= action.ap_cost
	s_queue_changed.emit()
	
func on_turn_confirmed() -> void:
	#append_enemy_moves()
	if !(queue.size() > 0):
		print("Action Queue size invalid")
		return
	execute_round()
	
func execute_round() -> void:
	for action in queue:
		if action is QueuedAction:
			current_action = action
			await run_action(action)
			current_action = null
		else:
			print("Next action is null, skipping")
	s_queue_finished.emit()
	
func run_action(action: QueuedAction) -> void:
	for combatant in ['user', 'target']:
		if !is_instance_valid(action[combatant]): return
	
	var battle_action: BattleAction = action.action
	var action_node := ActionScript.new()
	if battle_action.action_script:
		action_node.set_script(battle_action.action_script)
		for combatant in ['user', 'target', 'alt_targets']:
			if action[combatant] is Combatant:
				action_node[combatant] = action[combatant]
		action_node.manager = manager
		action_node.values = battle_action.values
		add_child(action_node)
		if action_node is ActionScript:
			action_node.s_cut_state_entered.connect(cut_manager.set_cut_state_client)
			s_action_script_started.emit(action_node)
			action_node.action()
			await action_node.s_action_end
	action_node.queue_free()

func reset_queue() -> void:
	queue.clear()
	queue.resize(manager.move_total)


## Removes dead combatants from everything
func scrub_battle() -> void:
	for action in queue:
		scrub_action(action)
	## TODO: Scrub status effects

func scrub_action(action: QueuedAction) -> void:
	if not action.user in manager.combatants:
		queue.erase(action)
		return
	for combatant in action.targets.duplicate():
		if not combatant in manager.combatants:
			action.targets.erase(combatant)
	if action.targets.is_empty():
		queue.erase(action)
