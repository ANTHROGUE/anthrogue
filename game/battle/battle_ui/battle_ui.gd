extends Control

const MASCOT_PANEL = preload("uid://djrshqlncgwga")
const MOVESET_PANEL = preload("uid://dbq0o58revbhn")
const ENEMY_PANEL = preload("uid://cvcfuubl4jdr6")

@onready var battle_node: BattleNode = get_parent().get_parent()
@onready var manager: BattleManager = get_parent()

var mascot_panels: Array[CombatantPanel] = []
var enemy_panels: Array[CombatantPanel] = []

signal s_turn_confirmed()
signal s_move_queued(move: BattleAction, user: Combatant, targets: Array[Combatant])

func _ready() -> void:
	setup_combatant_panels()
	%AnimationPlayer.play("battleui_in")

func on_go_pressed() -> void:
	# s_move_queued.emit(load('res://ar/registry/battle/actions/test/test_action.tres'), Player.instance, targets)
	_on_action_button_pressed()
	s_turn_confirmed.emit()


func _on_action_button_pressed() -> void:
	var target: Combatant = get_parent().get_parent().enemies[0]
	var targets: Array[Combatant] = []
	#var new_move = load('res://ar/registry/battle/actions/test/test_action.tres')
	var new_move = load("res://game/battle/actions/test_actions/test_strike.tres")
	# new_move.action_script.TEST_STRING = str(i)
	s_move_queued.emit(new_move, Player.instance, target, targets)
	pass # Replace with function body.

func setup_combatant_panels() -> void:
	for combatant in manager.combatants:
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

func update_panels() -> void:
	for array in [mascot_panels, enemy_panels]:
		for panel: CombatantPanel in array:
			panel = panel.refresh_panel() if CombatantPanel else array.erase(panel)
