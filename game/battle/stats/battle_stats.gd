extends Node
class_name BattleStats


#region Standard Stats
## HP:
## Hit Points (Health)
@export var hp := 10.0
@export var max_hp := 10.0

## Damage:
## The base power of a combatant's attacks
@export var damage := 1.0

## Defense:
## Used to diminish the effects of Damage from outward sources
@export var defense := 1.0

## Accuracy:
## The base likelihood of a combatant to land an attack on their opponent
@export var accuracy := 1.0

## Dexterity:
## Used to diminish an opponent's accuracy
@export var dexterity := 1.0

## Agility:
## The movement speed of the character, may also influence turn order
@export var agility := 1.0

## Luck:
## Crit chance, also has interactions with other game elements
@export var luck := 1.0

## Moves:
## The amount of times the combatant is allowed to attack per-round
@export var moves := 1
#endregion

## Combatant Tags
enum CombatantTag {
	IS_PLAYER, # Self-explanatory
	PERFECT_ACCURACY, # This combatant cannot miss an attack
}
@export var tags: Array[CombatantTag] = []
