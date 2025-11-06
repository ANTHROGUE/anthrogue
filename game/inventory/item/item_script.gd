extends Node
class_name ItemScript


## Default action when first collected or loaded from save
func setup() -> void:
	pass

## Action to take on collect
func on_collect() -> void:
	setup()

## Action to take when the item is loaded from save
func on_load() -> void:
	setup()

## Action to take on removal
func on_removed() -> void:
	pass
