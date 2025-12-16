extends ZoneElement
class_name ZoneExit

signal s_zone_exit_entered(exit: ZoneExit)

func interact() -> void:
	print("ZoneExit: Going!")
	s_zone_exit_entered.emit(self)
