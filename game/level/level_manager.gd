extends Node
class_name LevelManager

func _init() -> void:
	GameLoader.queue_into(GameLoader.Phase.GAMEPLAY, self, {
		'ZONE': "uid://cfulvjn770vuy",
		'ROOM_TRANSITION': "uid://63u4vcjeqr3k"
	})
	
	GameLoader.load_all()

var ZONE: PackedScene

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

@export var current_coord: Vector2i = Vector2i(0, 1)

@export var landmark_coords: Dictionary[String, Vector2i] = {}

class StoredZone:
	var zone: Zone
	var zone_type: ZoneType
	var zone_coord: Vector2i
	var flags: Array

func go_to_zone(_coord: Vector2i, relative := false) -> void:
	var coord := _coord
	if relative:
		coord += current_coord
	
	if !coord < zone_map_range or !coord >= Vector2i(0, 0):
		printerr("LevelManager: Attempted to go to non-existend map coordinate %s" % _coord)
		Player.instance.request_state(&"Walk")
		return
	
	print("LevelManager: %s -> %s" % [current_coord, coord])
	current_coord = coord
	# TODO Load scene in coord
	SceneLoader.change_scene_to_packed(ZONE)
