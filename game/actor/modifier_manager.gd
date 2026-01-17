extends Node
class_name ModifierManager

signal s_cbmodifier_added(modifier: CombatantModifier)

enum ModifierSource {
	Items,
	StatusEffects
}

var modifiers: Dictionary[String, Array] = {}

@onready var combatant: Combatant = get_parent()

func _ready() -> void:
	for n in ModifierSource.keys():
		var node = Node.new()
		node.name = n
		add_child(node)
		modifiers.set(n, [])

func add_modifier(mod_node: CombatantModifier, mod_source: ModifierSource) -> void:
	var source_string: String = ModifierSource.find_key(mod_source)
	get_node(source_string).add_child(mod_node)
	modifiers[source_string].append(mod_node)
	s_cbmodifier_added.emit(mod_node)

func remove_modifier(mod_node: CombatantModifier) -> void:
	pass
