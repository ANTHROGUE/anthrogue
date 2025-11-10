extends Node
class_name BattleManager


const BATTLE_UI := preload('res://game/battle/battle_ui/battle_ui.tscn')

class QueuedAction:
	var user: Combatant
	var targets: Array[Combatant] = []
	var action: BattleAction

var combatants: Array[Combatant] = []
var battle_ui: Control
var action_queue: Array[QueuedAction] = []


func _ready() -> void:
	battle_ui = BATTLE_UI.instantiate()
	battle_ui.s_move_queued.connect(queue_action)
	battle_ui.s_turn_confirmed.connect(on_turn_confirmed)
	add_child(battle_ui)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func on_turn_confirmed() -> void:
	append_enemy_moves()
	begin_round()
	battle_ui.hide()

func queue_action(action: BattleAction, user: Combatant = null, targets: Array[Combatant] = []) -> void:
	var queued_action := QueuedAction.new()
	queued_action.user = user
	queued_action.targets = targets
	queued_action.action = action
	action_queue.append(queued_action)

func append_enemy_moves() -> void:
	for combatant in combatants:
		if combatant is Enemy:
			queue_action(combatant.get_action())

func begin_round() -> void:
	while not action_queue.is_empty():
		await run_action(action_queue.pop_front())
	battle_ui.show()

func run_action(action: QueuedAction) -> void:
	var battle_action: BattleAction = action.action
	var action_node := Node.new()
	if battle_action.action_script:
		action_node.set_script(battle_action.action_script)
		add_child(action_node)
		if action_node is ActionScript:
			await action_node.action()
	action_node.queue_free()
