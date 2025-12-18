extends ZoneElement
class_name ZoneExit

signal s_zone_exit_entered(exit: ZoneExit)

@export var to_coord: Vector2i
@export var coord_relative := true

func interact() -> void:
	Player.instance.request_state(&'Stopped')
	print("ZoneExit: Going! %s %s" % [to_coord, "relative" if coord_relative else ""])
	s_zone_exit_entered.emit(self)
