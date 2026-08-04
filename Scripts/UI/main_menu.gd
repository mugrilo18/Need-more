extends CanvasLayer

@onready var settings_menu: Panel = $SettingsMenu


func _on_play_btn_button_down() -> void:
	get_tree().change_scene_to_file("res://Scenes/Components/World/world.tscn")
	settings_menu.visible = false


func _on_settings_btn_button_down() -> void:
	settings_menu.visible = true


func _on_quit_btn_button_down() -> void:
	get_tree().quit()
