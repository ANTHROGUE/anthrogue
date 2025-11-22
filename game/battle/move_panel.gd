extends Control
class_name MovePanel

var queued_action: BattleManager.QueuedAction:
	set(x):
		if x is BattleManager.QueuedAction:
			%ActionIcon.texture = x.action.icon
		else:
			%ActionIcon.texture = null
		queued_action = x
