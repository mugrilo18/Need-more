extends Node

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if Input.is_action_just_pressed("quit"):
			get_tree().quit()
		
		if Input.is_action_just_pressed("restart"):
			get_tree().change_scene_to_file("res://Scenes/Components/World/world.tscn")
			PlayerStatus.oil_charge = 100
		
		if Input.is_action_just_pressed("lantern") and PlayerStatus.lantern == false:
			print("Ligou o lampião")
			PlayerStatus.lantern = true
		elif Input.is_action_just_pressed("lantern") and PlayerStatus.lantern == true:
			print("Desligou o lampião")
			PlayerStatus.lantern = false
			
