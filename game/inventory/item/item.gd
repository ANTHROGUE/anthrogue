extends Resource
class_name Item


## 5-Star rating system
enum QualityRating {
	NIL,
	Q1,
	Q2,
	Q3,
	Q4,
	Q5
}

## The name of the Item in-game
@export var name: StringName

## The star rating of the Item
@export var quality := QualityRating.Q1

## The flavortext shown when the Item is picked up
@export_multiline var tagline: String

## A brief description of the Item and what it does.
## Two sentence maximum suggested.
@export_multiline var description: String

## Script to be attached to the Player.
## Needs to inherit from ItemScript.
@export var item_script: Script

## The id assigned to this item to be restored upon loading
var item_id: int

## The node associated with this Item's script
var node: ItemScript


# TODO
func apply_item() -> void:
	pass

# TODO
func remove_item() -> void:
	pass
