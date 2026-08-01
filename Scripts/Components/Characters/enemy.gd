extends CharacterBody3D

@export var player_ref: CharacterBody3D
@export var navigation_agent: NavigationAgent3D


func _process(_delta: float) -> void:
	navigation_agent.target_position = player_ref.global_position
	move_and_slide()
