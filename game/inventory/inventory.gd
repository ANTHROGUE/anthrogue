extends Resource
class_name Inventory


## Storage for Items, consumables, weapons, etc. that the player has

## Passive Items
@export var items: Array[Item] = []

## Items that require direct input from the player
@export var active_items: Array ## TODO

## One-time use pickups
@export var consumables: Array ## TODO

## BANGRS: 1 Weapon (Equip), 4 Talents (Learn)
@export var weapon: Weapon
@export var actions: Array[PlayerAction] = [] ## TODO
@export var action_cap = 4

## Point Pools
## Points allocated to using specific weapons
### UNUSED IN BANGRS
@export var point_pools: Dictionary[StringName, int] = {}
