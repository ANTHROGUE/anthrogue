extends CombatantPanel
class_name MovesetPanel

const TALENT_BUTTON = preload("uid://byo54fus7gfit")
var talent_buttons: Array[ActionButton]
var battle_ui
var manager: BattleManager:
	set(x):
		x.s_queue_changed.connect(refresh_panel)
		manager = x

func setup_buttons() -> void:
	talent_buttons.clear()
	for button in %TalentUIContainer.get_children():
		button.queue_free()
	for talent in user.inventory.actions:
		var button: Button = TALENT_BUTTON.instantiate()
		%TalentUIContainer.add_child(button)
		button.get_node("Label").text = talent.name
		button.action = talent
		talent_buttons.append(button)
		if battle_ui != null:
			button.pressed.connect(battle_ui.s_move_selected.emit.bind(talent, user))
	
func refresh_panel() -> void:
	super()
	for button: ActionButton in talent_buttons:
		button.disabled = !is_usable_action(button.action)

func setup_panel() -> void:
	super()
	setup_buttons()

func is_usable_action(action: BattleAction) -> bool:
	return (user.stats.ap >= action.ap_cost) && (manager.move_counts[user].x < manager.move_counts[user].y)
