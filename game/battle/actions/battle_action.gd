extends Resource
class_name BattleAction

enum TARGETING {
	EnemySingle,
	EnemyAll,
	AllyAny,
	AllyOther,
	AllyAll,
	Self
}

## Action name displayed in-game
@export var name: StringName

## AP cost for player action use
@export var ap_cost := 0

## Displayed icon
@export var icon: Texture2D

## Summary displayed during round, or on UI
@export_multiline var summary: String

## Must be an ActionScript
@export var action_script: Script

## Stats
@export var values = []
@export var targeting: TARGETING


## Move stats displayed on UI
func get_stat_display() -> String:
	return ""
