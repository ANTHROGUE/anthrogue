extends ActionScript

func action() -> void:
	ival_path = "uid://c80tj678kqkkk"
	super()

func end_action() -> void:
	super()

func impact() -> void:
	super()
	if values[0] is int: inflict_attack(values[0])
