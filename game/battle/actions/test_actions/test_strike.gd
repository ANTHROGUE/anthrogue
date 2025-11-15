extends ActionScript

func action() -> void:
	battle_node.animation_player.play("action-test_strike")
	battle_node.animation_player.animation_finished.connect(end_action)

func end_action() -> void:
	battle_node.animation_player.animation_finished.disconnect(end_action)
	super()
