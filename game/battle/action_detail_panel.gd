extends Control

@onready var label = $DetailLabel
@onready var icon = $ActionIcon

var action: BattleAction:
	set(x):
		if x is BattleAction:
			show()
			label.text = parse_summary(x)
			icon.texture = x.icon
		else:
			hide()
		action = x

var battle_ui: BattleUI:
	set(x):
		x.s_move_hovered.connect(func(a): action = a)
		battle_ui = x

func parse_summary(a: BattleAction) -> String:
	var __out := a.summary
	for i in range(a.values.size()):
		__out = __out.replace("$%d" % i, str(a.values[i]))
	return __out
