extends Control
class_name BattleUI

const PRELOADS = {
	"MASCOT_PANEL": preload("uid://djrshqlncgwga"),
	"MOVESET_PANEL": preload("uid://dbq0o58revbhn"),
	"ENEMY_PANEL": preload("uid://cvcfuubl4jdr6")
}

@onready var battle_node: BattleNode = get_parent().get_parent()
@onready var manager: BattleManager = get_parent()

var mascot_panels: Array[CombatantPanel] = []
var enemy_panels: Array[CombatantPanel] = []

## Targeting
var targeting_action: BattleAction
var targeting_user: Combatant
var targeting_timing: int = -1
var targeting_panels: Array[CombatantPanel] = []

var moveset_panel: MovesetPanel
@onready var move_timeline: MoveTimeline = %MoveTimeline

signal s_move_queued(move: BattleAction, user: Combatant, targets: Array[Combatant], timing: int, loose: bool)
signal s_move_selected(move: BattleAction, user: Combatant)
signal s_move_hovered(move: BattleAction)

func _ready() -> void:
	# bruh
	Player.instance.stats.max_hp = 30
	Player.instance.stats.hp = 30
	Player.instance.stats.moves = 3
	update_moveset_panel(Player.instance)
	move_timeline.battle_ui = self
	s_move_selected.connect(set_targeting_panels)
	
	manager.s_new_round.connect(on_new_round)
	
func on_new_round() -> void:
	if manager.current_round < 2:
		%AnimationPlayer.play("battleui_in")
	else:
		%AnimationPlayer.play_backwards("battleui_to-movie")
	update_panels()

func on_go_pressed() -> void:
	# s_move_queued.emit(load('res://ar/registry/battle/actions/test/test_action.tres'), Player.instance, targets)
	# _on_action_button_pressed()
	%AnimationPlayer.play("battleui_to-movie")
	# risking softlocks for the aura
	await %AnimationPlayer.animation_finished
	manager.s_turn_confirmed.emit()

func _on_action_button_pressed() -> void:
	var target: Combatant = get_parent().get_parent().enemies[0]
	var targets: Array[Combatant] = []
	#var new_move = load('res://ar/registry/battle/actions/test/test_action.tres')
	var new_move = load("res://game/battle/actions/test_actions/test_strike.tres")
	# new_move.action_script.TEST_STRING = str(i)
	s_move_queued.emit(new_move, Player.instance, target, targets, -1, false)
	pass # Replace with function body.

func setup_panels() -> void:
	var rev: Array[Combatant] = manager.combatants
	rev.reverse()
	
	mascot_panels.clear()
	enemy_panels.clear()
	
	for combatant in rev:
		var new_panel: CombatantPanel
		if combatant.is_in_group("Combatant_Ally"):
			if combatant.panel == null:
				new_panel = PRELOADS["MASCOT_PANEL"].instantiate()
				%MascotPanelContainer.add_child(new_panel)
				combatant.panel = new_panel
			else:
				new_panel = combatant.panel
			mascot_panels.append(new_panel)
		elif combatant.is_in_group("Combatant_Enemy"):
			if combatant.panel == null: 
				new_panel = PRELOADS["ENEMY_PANEL"].instantiate()
				%EnemyPanelContainer.add_child(new_panel)
				combatant.panel = new_panel
			else:
				new_panel = combatant.panel
			enemy_panels.append(new_panel)
		new_panel.user = combatant

func update_moveset_panel(combatant: Combatant) -> void:
	if moveset_panel is MovesetPanel:
		moveset_panel.queue_free()
	moveset_panel = PRELOADS['MOVESET_PANEL'].instantiate()
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
			for connection in button.pressed.get_connections():
				button.pressed.disconnect(connection['callable'])

func set_target(target: Combatant) -> void:
	if target == null:
		print("Received no target, cancelling")
	var x: Array[Combatant] = []
	if target is Combatant:
		s_move_queued.emit(targeting_action, targeting_user, target, x, targeting_timing, false)
	if moveset_panel is MovesetPanel:
		moveset_panel.refresh_panel()
	refresh_stats()
	targeting_panels.clear()
	update_target_buttons()

func refresh_stats() -> void:
	%MovesLabel.text = "Moves Filled: %d / %d" % [manager.move_counts[Player.instance].x, manager.move_counts[Player.instance].y]
	for panel in mascot_panels + enemy_panels + [moveset_panel]:
		if panel is CombatantPanel: panel.refresh_panel()

func update_panels() -> void:
	setup_panels()
	for array in [mascot_panels, enemy_panels]:
		for panel: CombatantPanel in array:
			panel.refresh_panel()
