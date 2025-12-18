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

var current_coord: Vector2i

class StoredZone:
	var zone: Zone
	var zone_type: ZoneType
	var zone_coord: Vector2i
	var flags: Array

func go_to_zone(_coord: Vector2i) -> void:
	if !_coord < zone_map_range or !_coord >= Vector2i(0, 0):
		printerr("LevelManager: Attempted to go to non-existend map coordinate %s" % _coord)
		return
	
	current_coord = _coord
	# TODO Load scene in coord
	pass
