extends ActionScript

func action() -> void:
	#ival_path = "uid://c80tj678kqkkk"
	super()
	await get_tree().create_timer(1.0).timeout
	end_action()

func end_action() -> void:
	super()

func impact() -> void:
	super()
	if values[0] is int: target.stats.block += values[0]
