extends Control

func _on_volume_value_changed(value: float) -> void:
	var linear = value / 100.0
	var db = linear_to_db(linear)
	AudioServer.set_bus_volume_db(0, db)


func _on_resolutions_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1920, 1080))
		1:
			DisplayServer.window_set_size(Vector2i(1600, 900))
		2:
			DisplayServer.window_set_size(Vector2i(1280, 720))
		3:
			DisplayServer.window_set_size(Vector2i(960, 540))	


func _on_mute_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(0,toggled_on)
	


func _on_alt_music_toggled(toggled_on):
	var mainMusicStream = get_tree().root.get_node("BaseNode").get_node("AudioStreamPlayer")
	var timePosition = mainMusicStream.get_playback_position()
	if toggled_on:
		mainMusicStream.stream = load("res://Assets/Audio/HardcoreTheme.mp3")
		
	else:
		mainMusicStream.stream = load("res://Assets/Audio/DefaultTheme.mp3")
		
	mainMusicStream.play()
	mainMusicStream.seek(timePosition)
