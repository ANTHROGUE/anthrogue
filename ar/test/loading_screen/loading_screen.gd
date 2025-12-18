extends Control


func load_scene(scene_path: String, load_phase: GameLoader.Phase = GameLoader.Phase.GAME_START) -> void:
	$ProgressBar.value = GameLoader.get_load_progress(load_phase)
	ResourceLoader.load_threaded_request(scene_path)
	while not $ProgressBar.value >= 1.0:
		await get_tree().process_frame
		$ProgressBar.value = GameLoader.get_load_progress(load_phase)
	
	var percentage_arr := []
	while ResourceLoader.load_threaded_get_status(scene_path, percentage_arr) == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		await get_tree().process_frame
		$ProgressBar.value = percentage_arr[0]
	
	SceneLoader.change_scene_to_packed(ResourceLoader.load_threaded_get(scene_path))
