extends Actor3D
class_name Combatant



## Class of Actors who can participate in battle
@export var stats_preset: Dictionary[String, Variant] = {}

## Tags to initialize the Combatant with
@export var combatant_tags: Array[BattleStats.CombatantTag] = []

## Node that tracks the stats of the Combatant
@export var stats: BattleStats
@export var inventory: Inventory
var panel: CombatantPanel

var cbmods: ModifierManager


func _ready() -> void:
	stats = initialize_stats()
	stats.s_hp_changed.connect(func():
		if stats.hp <= 0:
			queue_free()
	)
	
	if cbmods is not ModifierManager:
		cbmods = ModifierManager.new()
		cbmods.name = "ModifierManager"
		add_child(cbmods)

func lose() -> void:
	pass

func initialize_stats() -> BattleStats:
	var new_stats := BattleStats.new()
	for stat in stats_preset.keys():
		if stat in new_stats:
			new_stats[stat] = stats_preset[stat]
	add_child(new_stats)

	return new_stats
	
func affect_health(amount: int) -> void:
	affect_stat(amount, 'hp')

func affect_stat(amount: int, stat: String = 'hp') -> void:
	if stat not in stats:
		print("Stat %s not found in %s!" % [stat, name])
		return
	stats[stat] += amount

func get_weapon() -> Weapon:
	if inventory is Inventory: return inventory.weapon
	return null

func tick_round_start() -> void:
	if stats is BattleStats:	
		stats.ap = clamp(stats.ap + stats.ap_regen, 0, stats.max_ap)
		stats.block_peak = stats.block
		
	if get_weapon():
		get_weapon().regen_charges()

func inflict(data: InflictDatagram) -> void:
	match data.tag:
		data.InflictTags.DAMAGE:
			data.target.stats.take_damage(data.values[0], data.values[1])
