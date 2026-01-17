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

## The combatant that this Item is applied to
var combatant: Combatant

# Item is applied when equipped from inventory - it is stored when acquired but must be activated
func apply_item(_combatant: Combatant, _object: Node3D = null) -> void:
	if combatant is Combatant:
		print("Item: %s already assigned to Combatant %s, attempting removal first" % [name, combatant.name])
		remove_item()
		combatant = null
	
	if _combatant.cbmods is ModifierManager and item_script is Script:
		node = item_script.new()
		_combatant.cbmods.add_modifier(node, ModifierManager.ModifierSource.Items)
	
	combatant = _combatant


func remove_item() -> void:
	if combatant is not Combatant:
		printerr("Item: %s attempted removal with no assigned combatant" % name)
		return
	
	if node is not CombatantModifier:
		printerr("Item: %s attempted removal with no node" % name)
		return
	
	if combatant.cbmods is ModifierManager and node is CombatantModifier:
		combatant.cbmods.remove_modifier(node)
		node.queue_free()
		
	combatant = null
	node = null

func serialize() -> Dictionary:
	var dict: Dictionary[StringName, Variant]
	if is_instance_valid(node): dict = node.get_seralized_data()
	else: dict = {}
	
	# Add our instance values
	dict['id'] = item_id
	dict['registry_id'] = get_registry_id()
	
	return dict

#TODO
func get_registry_id() -> int:
	return -1
