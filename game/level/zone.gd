extends Node3D
class_name Zone

@export var elements: Array[ZoneElement]
@export var exits: Array[ZoneExit]

func _ready() -> void:
	Player.instance.transform = $PlayerSpawn.transform
	for exit: ZoneExit in exits:
		exit.s_zone_exit_entered.connect(func(x: ZoneExit): LevelService.manager.go_to_zone(x.to_coord, x.coord_relative))
