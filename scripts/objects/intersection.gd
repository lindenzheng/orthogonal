extends Area2D

@export var xScale = 1.0
@export var yScale = 1.0

func _ready() -> void:
	add_to_group("intersection")
	scale.x = xScale
	scale.y = yScale
