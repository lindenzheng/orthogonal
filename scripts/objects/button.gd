extends Area2D

signal button_pressed
signal button_released

@onready var sprite_normal = $CollisionShape2D/Button  # Normal sprite
@onready var sprite_pressed = $CollisionShape2D/ButtonPressed  # Pressed sprite
var objects_touching = 0

func _ready():
	sprite_pressed.visible = false  # Hide pressed sprite initially

func _on_Area2D_body_entered(body):
	if objects_touching == 0:  # Only press if it's the first contact
		_handle_button_press(body)
	objects_touching += 1

func _on_Area2D_body_exited(body):
	objects_touching -= 1
	if objects_touching == 0:  # Only release if no bodies are touching
		_handle_button_release(body)

# Handles button press actions
func _handle_button_press(body):
	emit_signal("button_pressed")  # Emit button pressed signal
	_set_sprite_visibility(true)

# Handles button release actions
func _handle_button_release(body):
	emit_signal("button_released")  # Emit button released signal
	_set_sprite_visibility(false)

# Set sprite visibility based on state
func _set_sprite_visibility(is_pressed):
	sprite_normal.visible = not is_pressed
	sprite_pressed.visible = is_pressed
