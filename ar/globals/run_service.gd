extends Node

class RogueRun:
	var run_seed: int
	var progress_data: ProgressData
	
	func _init(_seed := -1, _progress: ProgressData = null) -> void:
		run_seed = _seed
		progress_data = _progress

class ProgressData:
	var level: LevelManager
	
var current_run: RogueRun

signal s_run_loaded(run: RogueRun)

func initialize_run(_seed:= -1) -> void:
	current_run = RogueRun.new(_seed, ProgressData.new())

func enter_run() -> void:
	if !is_instance_valid(current_run):
		initialize_run()
		
	s_run_loaded.emit(current_run)
