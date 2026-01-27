extends Area2D

signal door_open
signal door_closed
signal teleport_player

@onready var sprite_normal = $CollisionShape2D/Door  # The normal sprite
@onready var sprite_pressed = $CollisionShape2D/DoorOpen  # The sprite for the pressed state

var location = self.global_position
var players_in_range = {}
var being_pressed = false
var is_active = false

func _ready():
	# Ensure the pressed sprite is hidden at the start
	sprite_pressed.visible = false
	location = self.global_position
	
# Called when the node enters the area
func _on_Area2D_body_entered(body):
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
			if ((Input.is_action_just_pressed("p1_interact") and player.name == "Player1") or (Input.is_action_just_pressed("p2_interact") and player.name == "Player2")) and not being_pressed:
				_open_door()

func _open_door():
	being_pressed = true
	print(self.name + " opened by ", players_in_range.keys()[0])  # Debug to show which player pressed
	await _animate_scale(sprite_pressed, Vector2(0.25, 0.25), Vector2(0.25, 0.25))
	print("doorOpen")
	emit_signal("door_open", players_in_range.keys()[0], location)
	print("doorClosed")
	await _animate_scale(sprite_normal, Vector2(0.25, 0.25), Vector2(0.25, 0.25))
	emit_signal("door_closed")
	being_pressed = false
	
func _animate_scale(sprite, start_scale, end_scale): 
	_toggle_sprite_visibility()
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "scale", start_scale, 0.3)
	await tween.finished
	sprite.scale = end_scale
	
func _toggle_sprite_visibility():
	sprite_normal.visible = !sprite_normal.visible
	sprite_pressed.visible = !sprite_pressed.visible

func _on_door_open(playerId, pairLocation):
	print("Door opened from ", pairLocation, " to ", location)
	emit_signal("teleport_player", playerId, location)
