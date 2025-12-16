extends Node3D
class_name ZoneDoor

@onready var detector: Area3D = %PlayerDetector

func _on_player_detector_body_entered(body: Node3D) -> void:
	if body == Player.instance:
		print("ZoneDoor: Player entered Area3D")
