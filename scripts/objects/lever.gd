extends Area2D

signal switch_on
signal switch_off

@onready var sprite_normal = $CollisionShape2D/Switch  # The normal sprite
@onready var sprite_pressed = $CollisionShape2D/SwitchPressed  # The sprite for the pressed state
var players_in_range = {}
var being_pressed = false
var is_active = false

func _ready():
	# Ensure the pressed sprite is hidden at the start
	sprite_pressed.visible = false

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
				_switch_switch()

func _switch_switch():
	being_pressed = true
	print(self.name + " pressed by ", players_in_range.keys()[0])  # Debug to show which player pressed
	await get_tree().create_timer(0.1).timeout
	_toggle_sprite_visibility()
	is_active = not is_active  # Switch switch on/off
	if is_active:
		emit_signal("switch_on")
	else:
		emit_signal("switch_off")
	being_pressed = false

func _toggle_sprite_visibility():
	sprite_normal.visible = !sprite_normal.visible
	sprite_pressed.visible = !sprite_pressed.visible

#extends Area2D
#
#signal lever_on
#signal lever_off
#
#@onready var sprite_normal = $CollisionShape2D/Lever  # The normal sprite
#@onready var sprite_pressed = $CollisionShape2D/LeverSwitched  # The sprite for the pressed state
#var players_in_range = {}
#var being_pressed = false
#var is_active = false
#
#func _ready():
	## Ensure the pressed sprite is hidden at the start
	#sprite_pressed.visible = false
#
## Called when the node enters the area
#func _on_Area2D_body_entered(body):
	#if body.is_in_group("player"):
		#players_in_range[body.get_instance_id()] = body
#
## Called when the node exits the area
#func _on_Area2D_body_exited(body):
	#if body.is_in_group("player"):
		#players_in_range.erase(body.get_instance_id())
#
#func _process(_delta):
	#if players_in_range.size() > 0:
		#for player_id in players_in_range.keys():
			#var player = players_in_range[player_id]
			#if ((Input.is_action_just_pressed("p1_interact") and player.name == "Player1") or (Input.is_action_just_pressed("p2_interact") and player.name == "Player2")) and not being_pressed:
				#_switch_lever()
#
#func _switch_lever():
	#being_pressed = true
	#print(self.name + " pressed by ", players_in_range.keys()[0])  # Debug to show which player pressed
	#await get_tree().create_timer(0.1).timeout
	#_toggle_sprite_visibility()
	#is_active = not is_active  # Switch lever on/off
	#if is_active:
		#emit_signal("lever_on")
	#else:
		#emit_signal("lever_off")
	#being_pressed = false
#
#func _toggle_sprite_visibility():
	#sprite_normal.visible = !sprite_normal.visible
	#sprite_pressed.visible = !sprite_pressed.visible
