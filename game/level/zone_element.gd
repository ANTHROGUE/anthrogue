@abstract class_name ZoneElement
extends Area3D

enum InteractTypes {
	PLAYER_ENTERED
}
@export var interact_tags: Array[InteractTypes]

@export var active := true

func _ready() -> void:
	if not Engine.is_editor_hint():
		set_collision_mask_value(Globals.COLLISION_LAYER_INTERACT, true)
		if not body_entered.is_connected(on_body_entered):
			body_entered.connect(on_body_entered)
		#%Pointer.queue_free()

func on_body_entered(body: Node3D) -> void:
	if body is Player and InteractTypes.PLAYER_ENTERED in interact_tags:
		pre_interact()

func pre_interact() -> void:
	if active and not Player.instance.controller.current_state_name == 'Stopped':
		interact()

@abstract func interact() -> void
