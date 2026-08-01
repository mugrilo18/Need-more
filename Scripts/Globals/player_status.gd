extends Node

var oil_charge: int = 100
var lantern: bool = false

func _reset_status():
	oil_charge = 100
	lantern = false
