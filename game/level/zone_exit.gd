extends ZoneElement
class_name ZoneExit

signal s_zone_exit_entered(exit: ZoneExit)

@export var to_coord: Vector2i
@export var coord_relative := true

func interact() -> void:
	print("ZoneExit: Going! %s %s" % [to_coord, coord_relative])
	s_zone_exit_entered.emit(self)
