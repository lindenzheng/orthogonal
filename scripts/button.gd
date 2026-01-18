extends Area2D

@onready var sprite_normal = $CollisionShape2D/Button  # The normal sprite
@onready var sprite_pressed = $CollisionShape2D/ButtonPressed  # The sprite for the pressed state
var objects_touching = 0
var is_animating = false

func _ready():
	# Ensure the pressed sprite is hidden at the start
	sprite_pressed.visible = false
	
# Called when the node enters the area
func _on_Button_body_entered(body):
	#print(body.name + " touched the button") #Debug
	if objects_touching == 0:
		print(body.name + " pressed the button!") #Debug
		if not is_animating:
			is_animating = true
			await _animate_scale(sprite_normal, Vector2(0.5, 0.25), Vector2(0.5, 0.5))
			_set_sprite_visibility(true)
	objects_touching += 1
	
func _animate_scale(sprite, start_scale, end_scale): 
	var tween = get_tree().create_tween() # Creates a tween (object that does a transition animation)
	tween.tween_property(sprite, "scale", start_scale, 0.075)  # Scales up/down
	await tween.finished # Wait until the tween finishes
	sprite.scale = end_scale # Scale back animation
	is_animating = false
	
func _set_sprite_visibility(is_pressed):
	sprite_normal.visible = not is_pressed
	sprite_pressed.visible = is_pressed

#func _toggle_sprite_visibility():
	#sprite_normal.visible = !sprite_normal.visible
	#sprite_pressed.visible = !sprite_pressed.visible

func _on_Area2D_body_exited(body):
	objects_touching -= 1
	#print(body.name + " exited the button") # Debug
	if objects_touching == 0:
		if not is_animating:
			is_animating = true
			print(body.name + " unpressed the button") # Debug
			await _animate_scale(sprite_pressed, Vector2(0.5, 0.5), Vector2(0.5, 0.15))
			_set_sprite_visibility(false)
