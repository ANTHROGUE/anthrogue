extends Node
class_name BattleStats


#region Standard Stats
## HP: Hit Points (Health)
## Affected by TGN
@export var hp := 10.0
@export var max_hp := 10.0

## AP: Action Points (Currency for using Talents)
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
## Agility: Scales real-time movement speed and affects move order
@export var agility := 1

#endregion

#region Variable Stats
## Damage Mult: Multiplier to outgoing damage
@export var damage_mult := 1.0
## Defense Mult: (Inverse) multiplier to incoming damage
@export var defense_mult := 1.0
## Damage Flatt: Added to outoging damage
## Affected by STR
@export var damage_flat := 0
## Defense Flat: Subtracted from incoming damage
@export var defense_flat := 0

## Moves: The amount of times the combatant is allowed to attack per-round
## Base before AGI bonus
@export var moves := 1
var current_moves := 1

## Bonus Move Agility Threshold: The amount of AGI needed to guarantee a bonus move
## Remainder gives a chance of getting another bonus move
@export var bonus_move_agility_thres := 4.0

## Accuracy: The base likelihood of a combatant to land an attack on their opponent
## Affected by DEX and LCK, should be 100% on non-debuffed player
@export var accuracy := 1.0

## Crit Chance: Percent-based roll per attack of getting a critical
## Affected by LCK
@export var crit_chance := 0.0
## Crit Mult: Multiplier applied to outgoing damage on a critical attack
## Affected by items
@export var crit_mult := 2.0

## Movespeed: Multiplier to base speed of platformer character
## Affected by AGI
@export var movespeed := 1.0

#endregion


## Combatant Tags
enum CombatantTag {
	IS_PLAYER, # Self-explanatory
	PERFECT_ACCURACY, # This combatant cannot miss an attack
	USE_BMAT # BANGRS: Gain more moves from Agility
}
@export var tags: Array[CombatantTag] = []


## Damage Tags
enum DamageTag {
	ATTACK,
	CRITICAL,
	TRUE_DAMAGE,
	TRAP,
	CUT,
	BONUS
}


func calculate_moves() -> int:
	current_moves = moves
	if CombatantTag.USE_BMAT in tags:
		var agi_moves := floori(agility / bonus_move_agility_thres)
		var agi_move_roll := int(randf() < ((agility / bonus_move_agility_thres) - agi_moves))
		if agi_move_roll > 0:
			print("%s gains %d move(s) from roll" % [get_parent().name, agi_move_roll])
		current_moves += agi_moves + agi_move_roll
	return current_moves
