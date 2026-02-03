extends Area2D

signal in_intersection
signal out_intersection

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	monitoring = true

func _on_area_entered(area: Area2D):
	if area.is_in_group("intersection"):
		emit_signal("in_intersection", area)
	
func _on_area_exited(area: Area2D):
	if area.is_in_group("intersection"):
		emit_signal("out_intersection", area)
