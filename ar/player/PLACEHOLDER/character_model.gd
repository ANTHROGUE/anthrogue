extends Node3D
class_name CharacterModel

@export var initial_anim := &""

signal s_animation_changed(anim: String)
signal s_animation_paused
signal s_animation_stopped

var anim: String
@onready var skeleton = %Skeleton3D
@onready var animator = %AnimationPlayer

func set_animation(_anim: String, custom_blend := -1, custom_speed := 1.0, from_end := false) -> void:
	if animator.has_animation(_anim):
		if animator.get_current_animation() != _anim:
			s_animation_changed.emit(_anim)
		skeleton.reset_bone_poses()
		animator.play(_anim, custom_blend, custom_speed, from_end)
		animator.advance(0.0)
	else:
		return
	
	anim = animator.current_animation
	
