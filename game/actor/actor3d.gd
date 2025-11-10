extends CharacterBody3D
class_name Actor3D


@export var animator: AnimationPlayer


func set_animation(anim: StringName, force_restart := true) -> void:
	if is_instance_valid(animator):
		printerr('ERR: Actor %s has no animator.' % get_actor_name())
		if animator.has_animation(anim):
			if animator.current_animation == anim and force_restart:
				animator.seek(0.0, true)
			else:
				animator.play(anim)
		else:
			printerr('ERR: Actor %s has no animation %s' % [get_actor_name(), anim])

func get_actor_name() -> StringName:
	return get_name()
