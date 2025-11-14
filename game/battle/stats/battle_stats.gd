extends Node
class_name BattleStats


#region Standard Stats
## HP:
## Hit Points (Health)
@export var hp := 10.0
@export var max_hp := 10.0

@export var ap := 7
@export var max_ap := 7
## AP Regen: Amount of AP gained at the start of a round
## Affected by DEX
@export var ap_regen := 1

## Strength: Scales flat damage
@export var strength := 0
## Toughness: Scales Max HP
@export var toughness := 0
## Dexterity: Scales dodge rate
@export var dexterity := 1
## Luck: Scales crit chance and odds of favorable outcomes in other events
@export var luck := 1
## Agility: The movement speed of the character, may also influence turn order
@export var agility := 1

#endregion

#region Variable Stats
## Moves: The amount of times the combatant is allowed to attack per-round
## Affected by AGI
@export var moves := 1
## Accuracy: The base likelihood of a combatant to land an attack on their opponent
## Affected by DEX and LCK, should be 100% on non-debuffed player
@export var accuracy := 1.0

## Crit Chance: Percent-based roll per attack of getting a Critical
## Affected by LCK
@export var crit_chance := 0.0
## Crit Mult: Multiplier applied to outgoing damage on a critical attack
## Affected by items
@export var crit_mult := 2.0

#endregion


## Combatant Tags
enum CombatantTag {
	IS_PLAYER, # Self-explanatory
	PERFECT_ACCURACY, # This combatant cannot miss an attack
}
@export var tags: Array[CombatantTag] = []
