extends StaticBody3D
class_name OilMachine

@export var player_ref: CharacterBody3D
@export var cooldown_machine: Timer

func _on_area_3d_2_body_entered(body: Node3D) -> void:
	if body.is_in_group("stick"):
		player_ref.grabbed_object = null
		body.queue_free()
		cooldown_machine.start()

func _on_cooldown_machine_timeout() -> void:
	PlayerStatus.oil_charge += 50
	print(PlayerStatus.oil_charge)
