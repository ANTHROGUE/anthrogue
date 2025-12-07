extends Node

var ongoing_battle: BattleManager
var battle_node: BattleNode
var cut_manager: CutManager:
	set(x):
		s_cut_manager_set.emit()
		cut_manager = x

signal s_cut_manager_set
signal s_battle_started(battle: BattleNode)

func get_cut_manager() -> CutManager:
	if cut_manager is not CutManager:
		await s_cut_manager_set
	return cut_manager

func _ready() -> void:
	s_battle_started.connect(connect_battle)
	
func connect_battle(battle: BattleNode):
	battle_node = battle
	ongoing_battle = battle.manager
