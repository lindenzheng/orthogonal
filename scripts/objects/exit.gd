extends Area2D

signal levelCompleted

@onready var sprite_normal = $Exit
@onready var sprite_pressed = $ExitOpen
var players_in_range = {}
var being_pressed = false
var exit_opening_delay = 0.5

func _ready():
	sprite_pressed.visible = false

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		players_in_range[body.get_instance_id()] = body

func _on_Area2D_body_exited(body):
	players_in_range.erase(body.get_instance_id())

func _process(_delta):
	for player_id in players_in_range.keys():
		var player = players_in_range[player_id]
		if is_interaction_valid(player):
			_open_exit(player_id)

func is_interaction_valid(player):
	return (player.name == "Player1" and Input.is_action_just_pressed("p1_interact") or
			player.name == "Player2" and Input.is_action_just_pressed("p2_interact")) and player.is_on_floor() and not being_pressed

func _open_exit(player_id):
	being_pressed = true
	print(self.name + " opened by ", player_id)
	_toggle_sprite_visibility()
	await get_tree().create_timer(exit_opening_delay).timeout
	_toggle_sprite_visibility()
	being_pressed = false
	emit_signal("levelCompleted")

func _toggle_sprite_visibility():
	sprite_normal.visible = !sprite_normal.visible
	sprite_pressed.visible = !sprite_pressed.visible
