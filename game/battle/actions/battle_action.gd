extends Resource
class_name BattleAction


## Action name displayed in-game
@export var name: StringName

## Summary displayed during round, or on UI
@export_multiline var summary: String

## Must be an ActionScript
@export var action_script: Script


## Move stats displayed on UI
func get_stat_display() -> String:
	return ""
