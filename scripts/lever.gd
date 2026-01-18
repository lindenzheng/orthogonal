extends Area2D

@onready var sprite_normal = $CollisionShape2D/Lever  # The normal sprite
@onready var sprite_pressed = $CollisionShape2D/LeverSwitched  # The sprite for the pressed state
var character_in_range = false

func _ready():
	# Ensure the pressed sprite is hidden at the start
	sprite_pressed.visible = false

# Called when the node enters the area
func _on_Button_body_entered(body):
	if body.is_in_group("player"):
		character_in_range = true

# Called when the node exits the area
func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		character_in_range = false

func _process(delta):
	if character_in_range && (Input.is_action_just_pressed("p1_interact") || Input.is_action_just_pressed("p2_interact")):
		_press_lever()

func _press_lever():
	print("Lever pressed!") # Debug
	await _animate_scale(sprite_pressed, Vector2(0.25, 0.25), Vector2(0.25, 0.25))

func _animate_scale(sprite, start_scale, end_scale): 
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "scale", start_scale, 0.075)
	await tween.finished
	_toggle_sprite_visibility()
	sprite.scale = end_scale

func _toggle_sprite_visibility():
	sprite_normal.visible = !sprite_normal.visible
	sprite_pressed.visible = !sprite_pressed.visible
