extends Area2D

@onready var sprite_normal = $CollisionShape2D/Button  # The normal sprite
@onready var sprite_pressed = $CollisionShape2D/ButtonPressed  # The sprite for the pressed state
@onready var objects_touching = 0
	
func _ready():
	# Ensure the pressed sprite is hidden at the start
	sprite_pressed.visible = false
	
# Called when the node enters the area
func _on_Button_body_entered(body):
	#print(body.name + " touched the button") #Debug
	if objects_touching == 0:
		print(body.name + " pressed the button!") #Debug
		_change_button_visuals()
	objects_touching += 1
		
func _change_button_visuals():
	#print("Animation!") # Debug
	await _animate_scale(sprite_normal, Vector2(10.0, 1.0), Vector2(10.0, 3.0))
	
func _animate_scale(sprite, start_scale, end_scale): 
	var tween = get_tree().create_tween() # Creates a tween (object that does a transition animation)
	tween.tween_property(sprite, "scale", start_scale, 0.075)  # Scales up/down
	await tween.finished # Wait until the tween finishes
	_toggle_sprite_visibility()
	sprite.scale = end_scale # Scale back animation
	
func _toggle_sprite_visibility():
	sprite_normal.visible = !sprite_normal.visible
	sprite_pressed.visible = !sprite_pressed.visible

func _on_Area2D_body_exited(body):
	objects_touching -= 1
	#print(body.name + " exited the button") # Debug
	if objects_touching == 0:
		print(body.name + " unpressed the button") # Debug
		await _animate_scale(sprite_pressed, Vector2(10.0, 3.0), Vector2(10.0, 1.0))
