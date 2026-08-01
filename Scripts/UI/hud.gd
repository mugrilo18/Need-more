extends CanvasLayer
class_name HUD

@export var progress_oil: TextureProgressBar

func _process(_delta: float) -> void:
	progress_oil.value = PlayerStatus.oil_charge
