extends Node3D
class_name Zone

@export var elements: Array[ZoneElement]
@export var exits: Dictionary[ZoneExit, Vector2i]

func _ready() -> void:
	for exit: ZoneExit in exits.keys():
		exit.s_zone_exit_entered.connect(exit.to_coord)
