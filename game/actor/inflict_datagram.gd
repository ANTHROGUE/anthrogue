extends Resource
class_name InflictDatagram

## Inflict Tags
enum InflictTags{
	DAMAGE,
	HEAL,
	STATUS_EFFECT,
}

var tag: InflictTags
var target: Combatant
var values: Array

func _init(_tag, _target, _values):
	tag = _tag
	target = _target
	values = _values
