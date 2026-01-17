extends Resource
class_name StatusEffect

enum EffectType {
	POSITIVE,
	NEGATIVE,
	NEUTRAL,
	UNIQUE
}

## The name of the Item in-game
@export var name: StringName

@export var status_effect_script: Script

# Effect Specific
@export var quality := EffectType.NEUTRAL
@export var rounds := 1
@export var rounds_offset := 0

@export var stacks := 1
@export var stacks_offset := 0

@export var stat_modifier: StatModifier

@export var icon: Texture2D = null
@export var icon_color := Color.WHITE
@export var icon_scale := 1.0
@export var mini_icon: Texture2D = null
@export var mini_icon_color := Color.WHITE
@export var mini_icon_scale := 1.0

@export var visible := true
@export_multiline var description := "This is a Status Effect"
@export var status_name := "Status Effect"

var target: Combatant
var manager: BattleManager

func apply_status_effect() -> void:
	if target.cbmods is ModifierManager:
		var new_node := StatusEffectScript.new()
		new_node.set_script(status_effect_script)
		new_node.effect_data = self.duplicate(true)
		target.cbmods.add_modifier(new_node, ModifierManager.ModifierSource.StatusEffects)
