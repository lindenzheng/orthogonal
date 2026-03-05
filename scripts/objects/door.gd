extends Area2D

signal door_is_open
signal door_is_closed
signal teleport_player

@onready var open = $Door
@onready var closed = $DoorOpen
var players_in_range = {}
var is_interacting = false
var delay = 0.5

func _ready():
	closed.visible = false

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		players_in_range[body.get_instance_id()] = body

func _on_Area2D_body_exited(body):
	players_in_range.erase(body.get_instance_id())

func _process(_delta):
	for player_id in players_in_range.keys():
		var player = players_in_range[player_id]
		if is_interaction_valid(player):
			_open_door(player_id)

func is_interaction_valid(player):
	return (player.name == "Player1" and Input.is_action_just_pressed("p1_interact") or
			player.name == "Player2" and Input.is_action_just_pressed("p2_interact")) and player.is_on_floor() and not is_interacting

# cosmetic
func _open_door(player_id):
	is_interacting = true
	_toggle_sprite_visibility()

	await get_tree().create_timer(delay).timeout

	emit_signal("door_is_open", player_id, self.global_position)
	_toggle_sprite_visibility()
	emit_signal("door_is_closed", player_id)
	is_interacting = false

func _toggle_sprite_visibility():
	open.visible = !open.visible
	closed.visible = !closed.visible

func _on_pair_door_open(player_id, pairLocation):
	print("Teleported from ", pairLocation, " to ", self.global_position)
	emit_signal("teleport_player", player_id, self.global_position)
	_toggle_sprite_visibility()

	await get_tree().create_timer(delay).timeout

	_toggle_sprite_visibility()
