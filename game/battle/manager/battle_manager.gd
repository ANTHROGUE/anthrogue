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
var player_moves_queued := 0


func _ready() -> void:
	battle_ui = BATTLE_UI.instantiate()
	battle_ui.s_move_queued.connect(queue_action)
	battle_ui.s_turn_confirmed.connect(on_turn_confirmed)
	battle_ui.s_move_selected.connect(select_action)
	add_child(battle_ui)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func on_turn_confirmed() -> void:
	append_enemy_moves()
	if !(action_queue.size() > 0):
		print("Action Queue size invalid")
		return
	begin_round()

func queue_action(action: BattleAction, user: Combatant = null, target: Combatant = null, alt_targets: Array[Combatant] = []) -> void:
	var __p := "Action Queued: %s from %s" % [action.name, user.name]
	if target is Combatant:
		__p += " targeting %s" % target.name
	print(__p)
	
	if user is Player:
		player_moves_queued += 1
	
	user.stats.ap -= action.ap_cost
	
	var queued_action := QueuedAction.new()
	queued_action.user = user
	queued_action.target = target
	queued_action.alt_targets = alt_targets
	queued_action.action = action
	action_queue.append(queued_action)

func append_enemy_moves() -> void:
	for combatant in combatants:
		if combatant is Enemy:
			queue_action(combatant.get_action(), combatant, Player.instance)

func begin_round() -> void:
	battle_ui.hide()
	for action in action_queue:
		await run_action(action)
	action_queue.clear()
	player_moves_queued = 0
	battle_ui.show()

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
