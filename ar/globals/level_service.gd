extends Node

var manager: LevelManager
var current_zone: Zone

func _ready() -> void:
	RunService.s_run_loaded.connect(func(x: RunService.RogueRun): load_level(x.progress_data.level))

func load_level(_manager: LevelManager) -> void:
	if _manager is LevelManager:
		manager = _manager
	else:
		manager = initialize_level()
	SceneLoader.persistent_node.add_child(manager)
	manager.go_to_zone(manager.current_coord)

func initialize_level() -> LevelManager:
	var _level = LevelManager.new()
	return _level
