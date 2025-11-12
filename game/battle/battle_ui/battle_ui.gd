extends Control


signal s_turn_confirmed()
signal s_move_queued(move: BattleAction, user: Player, targets: Array[Combatant])

func on_go_pressed() -> void:
	# s_move_queued.emit(load('res://ar/registry/battle/actions/test/test_action.tres'), Player.instance, targets)
	s_turn_confirmed.emit()


func _on_action_button_pressed() -> void:
	var targets: Array[Combatant] = []
	var new_move = load('res://ar/registry/battle/actions/test/test_action.tres')
	# new_move.action_script.TEST_STRING = str(i)
	s_move_queued.emit(new_move, Player.instance, targets)
	pass # Replace with function body.
