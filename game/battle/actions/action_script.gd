extends Node
class_name ActionScript

signal s_action_end
signal s_action_impact

## Override to script your battle movie
func action() -> void:
	s_action_impact.emit()
	pass

func end_action() -> void:
	print("End of Action %s" % name)
	s_action_end.emit()

func impact() -> void:
	print("Impact of Action %s" % name)
	s_action_impact.emit()
