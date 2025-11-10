extends Actor3D
class_name Combatant



## Class of Actors who can participate in battle
@export var stats_preset: Dictionary[String, Variant] = {}

## Tags to initialize the Combatant with
@export var combatant_tags: Array[BattleStats.CombatantTag] = []

## Node that tracks the stats of the Combatant
var stats: BattleStats


func _ready() -> void:
	stats = initialize_stats()

func initialize_stats() -> BattleStats:
	var new_stats := BattleStats.new()
	for stat in stats_preset:
		if stat in new_stats:
			new_stats.stat = stats[stat]
	add_child(new_stats)

	return new_stats
