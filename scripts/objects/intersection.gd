extends Area2D

@export var id = 0.0
var base_color_shift = 0.0

func _ready() -> void:
	add_to_group("intersection")
	var hue = fmod((id / 10) + base_color_shift, 1.0)
	$ColorRect.color = Color.from_hsv(hue, 0.3, 1)
