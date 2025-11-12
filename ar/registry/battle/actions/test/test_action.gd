extends ActionScript

var TEST_STRING: String = "TEST"

func action() -> void:
	print("3...")
	await get_tree().create_timer(0.3).timeout
	print("2...")
	await get_tree().create_timer(0.3).timeout
	print("1...")
	await get_tree().create_timer(0.3).timeout
	impact()
	await get_tree().create_timer(0.6).timeout
	print("HOORAY!! Move %s complete!!" % TEST_STRING)
	end_action()
