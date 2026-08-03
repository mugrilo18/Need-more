extends CanvasLayer

func _on_play_btn_button_down() -> void:
	get_tree().change_scene_to_file("res://Scenes/Components/World/world.tscn")
