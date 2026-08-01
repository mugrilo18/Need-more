extends Node

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if Input.is_action_just_pressed("quit"):
			get_tree().quit()
		
		if Input.is_action_just_pressed("restart"):
			get_tree().change_scene_to_file("res://Scenes/Components/World/world.tscn")
			PlayerStatus._reset_status()
		
		if Input.is_action_just_pressed("lantern") and PlayerStatus.lantern == false:
			PlayerStatus.lantern = true
		elif Input.is_action_just_pressed("lantern") and PlayerStatus.lantern == true:
			PlayerStatus.lantern = false
			
