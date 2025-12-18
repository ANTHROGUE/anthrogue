extends Control

var PLAYER: PackedScene

func _init() -> void:
	GameLoader.queue_into(GameLoader.Phase.PLAYER, self, {
		'PLAYER': "uid://cqpmi3pqv8kj2"
	})
	
	GameLoader.load_all()

func _on_button_pressed() -> void:
	begin_game()

func begin_game() -> void:
	await GameLoader.wait_for_phase(GameLoader.Phase.PLAYER)
	# Create the player object
	var player: Player = PLAYER.instantiate()
	player.stats = BattleStats.new()
	#player.stats.character = character.duplicate(true)
	#player.reset_stats()
	SceneLoader.add_persistent_node(player)
	#player.state = player.PlayerState.STOPPED
	
	RunService.enter_run()
