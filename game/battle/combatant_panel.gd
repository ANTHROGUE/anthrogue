extends Control
class_name CombatantPanel

var user: Combatant:
	set(x):
		user = x
		setup_panel()

func setup_panel() -> void:
	refresh_panel()
		
func refresh_panel() -> void:
	if user == null:
		queue_free()
	%Label_Name.text = user.name
	%Label_HP.text = "%d/%d" % [user.stats.hp, user.stats.max_hp]
	%Label_AP.text = "%d/%d" % [user.stats.ap, user.stats.max_ap]
