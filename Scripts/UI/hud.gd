extends CanvasLayer

@export var oil_charge: TextureProgressBar

func _process(delta: float) -> void:
	oil_charge.value = PlayerStatus.oil_charge
