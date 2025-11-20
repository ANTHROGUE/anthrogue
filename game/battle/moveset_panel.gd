extends CombatantPanel
class_name MovesetPanel

const TALENT_BUTTON = preload("uid://byo54fus7gfit")
var talent_buttons: Dictionary[Button, BattleAction]
var battle_ui

func refresh_panel() -> void:
	super()
	for talent in user.inventory.actions:
		var button: Button = TALENT_BUTTON.instantiate()
		%TalentUIContainer.add_child(button)
		if battle_ui != null:
			button.pressed.connect(battle_ui.s_move_selected.emit.bind(talent, user))
		button.get_node("Label").text = talent.name
		talent_buttons.set(button, talent)
