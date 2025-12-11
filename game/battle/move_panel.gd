extends Control
class_name MovePanel

signal s_move_cancelled

var user: Combatant:
	set(x):
		if user != x && user is Combatant:
			user.stats.s_hp_changed.disconnect(check_user)
		if x is Combatant:
			x.stats.s_hp_changed.connect(check_user)
		user = x
		check_user()

var queued_action: BattleTimeline.QueuedAction:
	set(x):
		if x is BattleTimeline.QueuedAction:
			%ActionIcon.texture = x.action.icon
			if x.user is Combatant:
				user = x.user
			if x.cancellable:
				%CancelButton.show()
				%CancelButton.disabled = false
		else:
			%ActionIcon.texture = null
			user = null
			%CancelButton.hide()
			%CancelButton.disabled = true
		queued_action = x

func check_user() -> void:
	if user is not Combatant || user.stats.hp <= 0:
		modulate = Color(0.3, 0.3, 0.3, 1.0)
		return
	modulate = Color(1.0, 1.0, 1.0, 1.0)


func _on_cancel_button_pressed() -> void:
	s_move_cancelled.emit()
