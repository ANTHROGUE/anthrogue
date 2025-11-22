extends CombatantPanel
class_name MovesetPanel

const TALENT_BUTTON = preload("uid://byo54fus7gfit")
var talent_buttons: Dictionary[Button, BattleAction]
var battle_ui
var manager: BattleManager

func setup_buttons() -> void:
	talent_buttons.clear()
	for button in %TalentUIContainer.get_children():
		button.queue_free()
	for talent in user.inventory.actions:
		var button: Button = TALENT_BUTTON.instantiate()
		%TalentUIContainer.add_child(button)
		button.get_node("Label").text = talent.name
		talent_buttons.set(button, talent)
		if battle_ui != null:
			button.pressed.connect(battle_ui.s_move_selected.emit.bind(talent, user))
	update_buttons()
	
func update_buttons() -> void:
	for button: ActionButton in talent_buttons.keys():
		button.disabled = !is_usable_action(talent_buttons[button])

func setup_panel() -> void:
	super()
	setup_buttons()

func is_usable_action(action: BattleAction) -> bool:
	return (user.stats.ap >= action.ap_cost) && (manager.player_moves_queued < user.stats.moves)
