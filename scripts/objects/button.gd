extends Area2D

signal button_pressed
signal button_released

@onready var sprite_normal = $CollisionShape2D/Button  # Normal sprite
@onready var sprite_pressed = $CollisionShape2D/ButtonPressed  # Pressed sprite
var objects_touching = 0
var is_animating = false

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
	#print(body.name + " pressed the button!")  # Debug
	emit_signal("button_pressed")  # Emit button pressed signal
	if not is_animating:
		is_animating = true
		await _animate_scale(sprite_normal, Vector2(0.5, 0.25), Vector2(0.5, 0.5))
		_set_sprite_visibility(true)

# Handles button release actions
func _handle_button_release(body):
	if not is_animating:
		is_animating = true
		#print(body.name + " unpressed the button")  # Debug
		emit_signal("button_released")  # Emit button released signal
		await _animate_scale(sprite_pressed, Vector2(0.5, 0.5), Vector2(0.5, 0.15))
		_set_sprite_visibility(false)

# Animate sprite scale
func _animate_scale(sprite, start_scale, end_scale):
	var tween = get_tree().create_tween()  # Create a tween for animation
	tween.tween_property(sprite, "scale", start_scale, 0.075)  # Scale effect (Like button press)
	await tween.finished  # Wait for animation to finish
	sprite.scale = end_scale  # Set final scale
	is_animating = false

# Set sprite visibility based on state
func _set_sprite_visibility(is_pressed):
	sprite_normal.visible = not is_pressed
	sprite_pressed.visible = is_pressed
