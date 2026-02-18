extends Area2D

signal door_open
signal door_closed
signal teleport_player

@onready var sprite_normal = $CollisionShape2D/Door  # The normal sprite
@onready var sprite_pressed = $CollisionShape2D/DoorOpen  # The sprite for the pressed state

var location = self.global_position # Location of door (to link two)
var players_in_range = {}
var being_pressed = false
var is_active = false
var pressedPlayerId: int

func _ready():
	# Ensure the pressed sprite is hidden at the start
	sprite_pressed.visible = false
	location = self.global_position
	
# Detect player at door
func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		players_in_range[body.get_instance_id()] = body

# Detect player away from door
func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		players_in_range.erase(body.get_instance_id())

func _process(_delta):
	if players_in_range.size() > 0:
		for player_id in players_in_range.keys():
			var player = players_in_range[player_id]
			if ((Input.is_action_just_pressed("p1_interact") and player.name == "Player1" and player.is_on_floor()) or (Input.is_action_just_pressed("p2_interact") and player.name == "Player2" and player.is_on_floor())) and not being_pressed:
				_open_door()

func _open_door():
	
	being_pressed = true # Door is pressed (Prevent opening spam)
	pressedPlayerId = players_in_range.keys()[0]
	print(self.name + " opened by ", pressedPlayerId)  # Debug to show which player pressed
	
	_toggle_sprite_visibility()
	await get_tree().create_timer(0.3).timeout
	emit_signal("door_open", pressedPlayerId, location)
	_toggle_sprite_visibility()
	await get_tree().create_timer(0.3).timeout
	
	emit_signal("door_closed")
	
	being_pressed = false # Door is not pressed (Allow opening)
	
func _toggle_sprite_visibility():
	sprite_normal.visible = !sprite_normal.visible
	sprite_pressed.visible = !sprite_pressed.visible

func _on_door_open(playerId, pairLocation):
	#print("Door opened from ", pairLocation, " to ", location)  # Debug
	emit_signal("teleport_player", playerId, location)
