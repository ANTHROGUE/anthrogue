extends BattleAction

func get_stat_display() -> String:
	var _str := ""
	if values[0] > 0:
		_str += "Deal %s damage" % values[0]
	return _str
