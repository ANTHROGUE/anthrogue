extends Control
class_name CombatantPanel

var user: Combatant:
	set(x):
		user = x
		if user.stats is BattleStats:
			user.stats.s_hp_changed.connect(refresh_panel)
			user.stats.s_ap_changed.connect(refresh_panel)
			user.stats.s_block_changed.connect(refresh_panel)
			user.tree_exiting.connect(queue_free)
		setup_panel()

func setup_panel() -> void:
	refresh_panel()
		
func refresh_panel() -> void:
	%Label_Name.text = user.name
	%Label_HP.text = "%d/%d" % [user.stats.hp, user.stats.max_hp]
	%Label_AP.text = "%d/%d" % [user.stats.ap, user.stats.max_ap]
	%Label_Block.text = "Block: %d" % user.stats.block
