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
var battle_node: BattleNode


func _ready() -> void:
	battle_ui = BATTLE_UI.instantiate()
	battle_ui.s_move_queued.connect(queue_action)
	battle_ui.s_turn_confirmed.connect(on_turn_confirmed)
	battle_ui.battle_manager = self
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
	end_round()

func end_round() -> void:
	if get_enemies().is_empty():
		end_battle()
		return
	battle_ui.show()

func end_battle() -> void:
	Player.instance.reparent(get_tree().current_scene)
	Player.instance.request_state('Walk')
	battle_node.queue_free()

func run_action(action: QueuedAction) -> void:
	var battle_action: BattleAction = action.action
	var action_node := Node.new()
	if battle_action.action_script:
		action_node.set_script(battle_action.action_script)
		add_child(action_node)
		if action_node is ActionScript:
			initialize_action(action_node, action)
			await action_node.action()
			await check_pulses(action.targets)
	action_node.queue_free()

func initialize_action(action: ActionScript, queued_action: QueuedAction) -> void:
	action.user = queued_action.user
	action.targets = queued_action.targets
	action.manager = self
	action.battle_node = battle_node

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

## Removes dead combatants from everything
func scrub_battle() -> void:
	for action in action_queue:
		scrub_action(action)
	## TODO: Scrub status effects

func scrub_action(action: QueuedAction) -> void:
	if not action.user in combatants:
		action_queue.erase(action)
		return
	for combatant in action.targets.duplicate():
		if not combatant in combatants:
			action.targets.erase(combatant)
	if action.targets.is_empty():
		action_queue.erase(action)

func remove_combatant(who: Combatant) -> void:
	combatants.erase(who)
	scrub_battle()
	@warning_ignore("redundant_await")
	await who.lose()
	who.queue_free()
