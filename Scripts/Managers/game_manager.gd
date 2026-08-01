extends Node

@export var countdown_oil: Timer

func _process(_delta: float) -> void:
	if PlayerStatus.lantern == false:
		countdown_oil.start()
	
	if PlayerStatus.oil_charge == 0:
		PlayerStatus.lantern = false

func _on_count_down_oil_timeout() -> void:
	if PlayerStatus.lantern == true and PlayerStatus.oil_charge > 0:
		PlayerStatus.oil_charge -= 10
