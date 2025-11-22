extends Control

const MASCOT_PANEL = preload("uid://djrshqlncgwga")
const MOVESET_PANEL = preload("uid://dbq0o58revbhn")
const ENEMY_PANEL = preload("uid://cvcfuubl4jdr6")

@onready var battle_node: BattleNode = get_parent().get_parent()
@onready var manager: BattleManager = get_parent()

var mascot_panels: Array[CombatantPanel] = []
var enemy_panels: Array[CombatantPanel] = []

## Targeting
var targeting_action: BattleAction
var targeting_user: Combatant
var targeting_panels: Array[CombatantPanel] = []

var moveset_panel: MovesetPanel

signal s_turn_confirmed()
signal s_move_queued(move: BattleAction, user: Combatant, targets: Array[Combatant])
signal s_move_selected(move: BattleAction, user: Combatant)

func _ready() -> void:
	Player.instance.stats.moves = 3
	setup_panels()
	update_moveset_panel(Player.instance)
	refresh_stats()
	s_move_selected.connect(set_targeting_panels)
	%AnimationPlayer.play("battleui_in")

func on_go_pressed() -> void:
	# s_move_queued.emit(load('res://ar/registry/battle/actions/test/test_action.tres'), Player.instance, targets)
	# _on_action_button_pressed()
	s_turn_confirmed.emit()

func _on_action_button_pressed() -> void:
	var target: Combatant = get_parent().get_parent().enemies[0]
	var targets: Array[Combatant] = []
	#var new_move = load('res://ar/registry/battle/actions/test/test_action.tres')
	var new_move = load("res://game/battle/actions/test_actions/test_strike.tres")
	# new_move.action_script.TEST_STRING = str(i)
	s_move_queued.emit(new_move, Player.instance, target, targets)
	pass # Replace with function body.

func setup_panels() -> void:
	var rev: Array[Combatant] = manager.combatants
	rev.reverse()
	for combatant in rev:
		if combatant.panel == null:
			var new_panel: CombatantPanel
			if combatant.is_in_group("Combatant_Ally"):
				new_panel = MASCOT_PANEL.instantiate()
				mascot_panels.append(new_panel)
				%MascotPanelContainer.add_child(new_panel)
			elif combatant.is_in_group("Combatant_Enemy"):
				new_panel = ENEMY_PANEL.instantiate()
				enemy_panels.append(new_panel)
				%EnemyPanelContainer.add_child(new_panel)
			combatant.panel = new_panel
			new_panel.user = combatant

func update_moveset_panel(combatant: Combatant) -> void:
	if moveset_panel is MovesetPanel:
		moveset_panel.queue_free()
	moveset_panel = MOVESET_PANEL.instantiate()
	moveset_panel.battle_ui = self
	moveset_panel.manager = manager
	moveset_panel.user = combatant
	%MovesetPanelContainer.add_child(moveset_panel)
	
func set_targeting_panels(move: BattleAction, user: Combatant) -> void:
	targeting_panels.clear()
	targeting_action = move
	targeting_user = user
	match move.targeting:
		BattleAction.TARGETING.EnemySingle:
			targeting_panels.append_array(enemy_panels)
		BattleAction.TARGETING.AllyAny:
			targeting_panels.append_array(mascot_panels)
		BattleAction.TARGETING.AllyOther:
			for panel: CombatantPanel in mascot_panels:
				if panel.user != user:
					targeting_panels.append(panel)
	if targeting_panels.size() > 0:
		update_target_buttons()
	
func update_target_buttons() -> void:
	var button: Button
	var callable: Callable
	for panel in mascot_panels + enemy_panels:
		button = panel.get_node("TargetButton")
		callable = set_target.bind(panel.user)
		if panel in targeting_panels:
			button.visible = true
			button.pressed.connect(callable)
		else:
			button.visible = false
			button.pressed.disconnect(callable)

func set_target(target: Combatant) -> void:
	if target == null:
		print("Received no target, cancelling")
	var x: Array[Combatant] = []
	if target is Combatant:
		s_move_queued.emit(targeting_action, targeting_user, target, x)
	if moveset_panel is MovesetPanel:
		moveset_panel.update_buttons()
	refresh_stats()
	targeting_panels.clear()
	update_target_buttons()

func refresh_stats() -> void:
	%MovesLabel.text = "Moves Filled: %d / %d" % [manager.player_moves_queued, Player.instance.stats.moves]
	for panel: CombatantPanel in mascot_panels + enemy_panels + [moveset_panel]:
		panel.refresh_panel()

func update_panels() -> void:
	for array in [mascot_panels, enemy_panels]:
		for panel: CombatantPanel in array:
			panel.refresh_panel()
			if panel.combatant == null: array.erase(panel)
