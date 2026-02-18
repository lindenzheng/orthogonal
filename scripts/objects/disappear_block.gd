extends StaticBody2D

@onready var collision_shape = $CollisionShape2D

func _on_signal_hide() -> void:
	self.visible = false
	collision_shape.set_deferred("disabled", true) # Hide the hitbox

func _on_signal_show() -> void:
	self.visible = true
	collision_shape.set_deferred("disabled", false) # Show the hitbox
