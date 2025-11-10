extends Control


signal s_turn_confirmed()
signal s_move_queued(move: BattleAction, user: Player, targets: Array[Combatant])

func on_button_pressed() -> void:
	var targets: Array[Combatant] = []
	s_move_queued.emit(load('res://ar/registry/battle/actions/test/test_action.tres'), Player.instance, targets)
	s_turn_confirmed.emit()
