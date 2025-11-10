extends Resource
class_name Inventory


## Storage for Items, consumables, weapons, etc. that the player has

## Passive Items
@export var items: Array[Item] = []

## Items that require direct input from the player
@export var active_items: Array ## TODO

## One-time use pickups
@export var consumables: Array ## TODO

## Current set of battle actions at the player's disposal
@export var weapons: Array[PlayerAction] = [] ## TODO

## Point Pools
## Points allocated to using specific weapons
@export var point_pools: Dictionary[StringName, int] = {}
