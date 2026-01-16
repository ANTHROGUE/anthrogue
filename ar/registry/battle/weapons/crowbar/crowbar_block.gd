extends ActionScript

func action() -> void:
	ival_path = "uid://bpu5e70h8m72l"
	super()


func end_action() -> void:
	super()

func impact() -> void:
	super()
	if values[0] is int: target.stats.block += values[0]
