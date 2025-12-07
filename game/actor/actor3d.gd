extends CharacterBody3D
class_name Actor3D


@export var animator: AnimationPlayer


func set_animation(anim: StringName, speed := 1.0, force_restart := true) -> void:
	if !is_instance_valid(animator):
		printerr('ERR: Actor %s has no animator.' % get_actor_name())
		return
		
	if animator.has_animation(anim):
		animator.speed_scale = speed
		if animator.current_animation == anim and force_restart:
			animator.seek(0.0, true)
		else:
			animator.play(anim)
	else:
		printerr('ERR: Actor %s has no animation %s' % [get_actor_name(), anim])
		
func get_animation() -> String:
	if !is_instance_valid(animator):
		printerr('ERR: Actor %s has no animator.' % get_actor_name())
		return ""
	
	return animator.current_animation

func get_actor_name() -> StringName:
	return get_name()
