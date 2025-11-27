extends Control
class_name MovePanel

var queued_action: BattleTimeline.QueuedAction:
	set(x):
		if x is BattleTimeline.QueuedAction:
			%ActionIcon.texture = x.action.icon
		else:
			%ActionIcon.texture = null
		queued_action = x
