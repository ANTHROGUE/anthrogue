extends Node
class_name LevelManager

enum ZoneType {
	ENTRANCE,
	OBSTACLE,
	BATTLE,
	ONE_TIME,
	PRE_FINAL,
	BOSS
}

var zones: Array[Array]
@export var zone_map_range: Vector2i = Vector2i(8, 4)

class StoredZone:
	var zone: Zone
	var zone_type: ZoneType
	var zone_coord: Vector2i
	var flags: Array

func go_to_zone(coord: Vector2i) -> void:
	pass
