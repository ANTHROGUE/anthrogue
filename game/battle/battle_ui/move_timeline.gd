extends Control
class_name MoveTimeline

const MOVE_PANEL = preload("uid://dfw8g4sirpc08")

var manager: BattleManager
var battle_ui: BattleUI:
	set(x):
		manager = x.manager
		#x.s_move_queued.connect(on_move_queued)
		manager.s_queue_changed.connect(refresh_panels)
		#manager.s_timeline_ready.connect(setup_panels)
		battle_ui = x
		setup_panels()

var move_panels: Array[MovePanel] = []

	
func setup_panels() -> void:
	clear_panels()
	if manager is not BattleManager:
		return
	move_panels.resize(manager.move_total)
	for i in manager.move_total:
		var panel = MOVE_PANEL.instantiate()
		%MovePanelContainer.add_child(panel)
		move_panels[i] = panel
	#refresh_panels()
	
	
func clear_panels() -> void:
	for panel in %MovePanelContainer.get_children():
		panel.queue_free()
	move_panels.clear()

func refresh_panels() -> void:
	if move_panels.size() != manager.move_total:
		setup_panels()
	for i in manager.action_queue.size():
		var panel = move_panels[i]
		if panel is not MovePanel:
			printerr("No move panel found")
			return
		panel.queued_action = manager.action_queue[i]

#func on_move_queued() -> void:
#	refresh_panels()
	
