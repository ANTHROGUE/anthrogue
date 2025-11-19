extends Control


signal s_turn_confirmed()
signal s_move_queued(move: BattleAction, user: Combatant, targets: Array[Combatant])

func _ready() -> void:
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
