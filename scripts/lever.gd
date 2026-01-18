extends Area2D

@onready var sprite_normal = $CollisionShape2D/Lever  # The normal sprite
@onready var sprite_pressed = $CollisionShape2D/LeverSwitched  # The sprite for the pressed state
var players_in_range = {}
var is_pressed = false

func _ready():
	# Ensure the pressed sprite is hidden at the start
	sprite_pressed.visible = false

# Called when the node enters the area
func _on_Button_body_entered(body):
	if body.is_in_group("player"):
		players_in_range[body.get_instance_id()] = body

# Called when the node exits the area
func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		players_in_range.erase(body.get_instance_id())

func _process(_delta):
	if players_in_range.size() > 0:
		for player_id in players_in_range.keys():
			var player = players_in_range[player_id]
			if ((Input.is_action_just_pressed("p1_interact") and player.name == "Player1") or (Input.is_action_just_pressed("p2_interact") and player.name == "Player2")) and not is_pressed:
				_press_lever()

func _press_lever():
	is_pressed = true
	print("Lever pressed by ", players_in_range.keys()[0]) # Debug to show which player pressed
	await _animate_scale(sprite_pressed, Vector2(0.25, 0.25), Vector2(0.25, 0.25))
	is_pressed = false
	
func _animate_scale(sprite, start_scale, end_scale): 
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "scale", start_scale, 0.075)
	await tween.finished
	_toggle_sprite_visibility()
	sprite.scale = end_scale
	
func _toggle_sprite_visibility():
	sprite_normal.visible = !sprite_normal.visible
	sprite_pressed.visible = !sprite_pressed.visible
