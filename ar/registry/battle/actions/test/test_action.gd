extends ActionScript


func action() -> void:
	print("3...")
	await get_tree().create_timer(1.0).timeout
	print("2...")
	await get_tree().create_timer(1.0).timeout
	print("1...")
	await get_tree().create_timer(1.0).timeout
	print("HOORAY!! Move complete!!")
	for target in targets:
		target.stats.hp = 0
