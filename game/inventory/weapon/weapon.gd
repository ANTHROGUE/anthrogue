extends Item
class_name Weapon

@export var action: BattleAction
@export var offense_cut: BattleAction
@export var offense_cd := 0
@export var defense_cut: BattleAction
@export var defense_cd := 0

var offense_cd_timer := 0
var defense_cd_timer := 0
