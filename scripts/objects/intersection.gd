extends Area2D

@export var xScale = 1.0
@export var yScale = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("intersection")
	scale.x = xScale
	scale.y = yScale
