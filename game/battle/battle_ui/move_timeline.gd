extends Control
class_name MoveTimeline

const MOVE_PANEL = preload("uid://dfw8g4sirpc08")

var move_panels: Dictionary[MovePanel, BattleAction] = {}

func setup_panels() -> void:
	clear_panels()
	
func clear_panels() -> void:
	for panel in move_panels.keys():
		panel.queue_free()
		move_panels.erase(panel)
