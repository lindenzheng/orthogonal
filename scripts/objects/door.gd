extends Area2D

signal door_open
signal door_closed
signal teleport_player

@onready var sprite_normal = $Door  # Normal sprite
@onready var sprite_pressed = $DoorOpen  # Pressed sprite

var players_in_range = {}
var being_pressed = false

func _ready():
	sprite_pressed.visible = false  # Hide pressed sprite initially

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		players_in_range[body.get_instance_id()] = body

func _on_Area2D_body_exited(body):
	players_in_range.erase(body.get_instance_id())

func _process(_delta):
	for player_id in players_in_range.keys():
		var player = players_in_range[player_id]
		if (Input.is_action_just_pressed("p1_interact") and player.name == "Player1" or 
			Input.is_action_just_pressed("p2_interact") and player.name == "Player2") and player.is_on_floor() and not being_pressed:
			_open_door()

func _open_door():
	being_pressed = true
	var pressedPlayerId = players_in_range.keys()[0]
	print(self.name + " opened by ", pressedPlayerId)  # Debug info

	_toggle_sprite_visibility()
	await get_tree().create_timer(0.3).timeout
	emit_signal("door_open", pressedPlayerId, self.global_position)
	_toggle_sprite_visibility()
	await get_tree().create_timer(0.3).timeout
	emit_signal("door_closed")
	being_pressed = false

func _toggle_sprite_visibility():
	sprite_normal.visible = !sprite_normal.visible
	sprite_pressed.visible = !sprite_pressed.visible

func _on_door_open(playerId, pairLocation):
	emit_signal("teleport_player", playerId, self.global_position)
	
