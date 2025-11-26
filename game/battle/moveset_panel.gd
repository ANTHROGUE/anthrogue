extends CombatantPanel
class_name MovesetPanel

const TALENT_BUTTON = preload("uid://byo54fus7gfit")
var action_buttons: Array[ActionButton]

var battle_ui
var manager: BattleManager:
	set(x):
		x.timeline.s_queue_changed.connect(refresh_panel)
		x.s_turn_confirmed.connect(hide)
		x.s_new_round.connect(show)
		manager = x

func setup_buttons() -> void:
	action_buttons.clear()
	
	## Talents
	for button in %TalentUIContainer.get_children():
		button.queue_free()
	for talent in user.inventory.actions:
		var button: Button = TALENT_BUTTON.instantiate()
		%TalentUIContainer.add_child(button)
		button.get_node("Label").text = talent.name
		button.action = talent
		action_buttons.append(button)
	
	## Weapon
	%WeaponButton.weapon = user.inventory.weapon
	if %WeaponButton.weapon is Weapon:
		action_buttons.append(%WeaponButton)
	
	## UI
	if battle_ui != null:
		%DetailPanel.battle_ui = battle_ui
		for button in action_buttons:
			button.mouse_entered.connect(battle_ui.s_move_hovered.emit.bind(button.action))
			button.mouse_exited.connect(battle_ui.s_move_hovered.emit.bind(null))
			button.pressed.connect(battle_ui.s_move_selected.emit.bind(button.action, user))
	
func refresh_panel() -> void:
	super()
	for button: ActionButton in action_buttons:
		button.disabled = !is_usable_action(button.action)

func setup_panel() -> void:
	super()
	$StatsPanel/StatsLabel.text = parse_stats()
	setup_buttons()

func is_usable_action(action: BattleAction) -> bool:
	return (user.stats.ap >= action.ap_cost) && (manager.move_counts[user].x < manager.move_counts[user].y)

func parse_stats() -> String:
	if user is not Combatant:
		$StatsPanel/StatsLabel.hide()
		return ""
	
	$StatsPanel/StatsLabel.show()
	return "STR: %d\nTGH: %d\nDEX: %d\nLCK: %d\nAGI: %d\n\nMoves: %d" % \
	[user.stats.strength, user.stats.toughness, user.stats.dexterity, user.stats.luck, user.stats.agility, user.stats.moves]
