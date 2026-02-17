extends CharacterBody2D

@export var controls: PlayerControls = null

const SPEED = 300.0
const PUSH_FORCE = 15.0
const MIN_PUSH_FORCE = 10.0
#const JUMP_VELOCITY = -400.0

var currently_pushing: RigidBody2D = null

func _ready():
	add_to_group("player")
	z_index = 99  # Sets layer to 99

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump. (Changed to interaction)
	if Input.is_action_just_pressed(controls.interact) and is_on_floor():
			print(self.name + " interacted (", self.get_instance_id(), ")")  # Debug
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_action_strength(controls.move_right) - Input.get_action_strength(controls.move_left)
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	# Object Push Code
	var pushing = false
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c. get_collider() is RigidBody2D:
			pushing = true
			var push_force = (PUSH_FORCE * velocity.length() / SPEED) + MIN_PUSH_FORCE
			c. get_collider(). apply_central_impulse(-c.get_normal() * push_force)
			if not c.get_collider().is_in_group("pushed"):
				c. get_collider(). add_to_group("pushed")
			currently_pushing = c.get_collider()

	# If not pushing any object, remove the last pushed object from the group
	if not pushing and currently_pushing:
		currently_pushing.remove_from_group("pushed")
		currently_pushing = null  # Reset the reference

func teleport_player(playerId, location):
	if self.get_instance_id() == playerId:
		self.position = location
		print(playerId, " was teleported to ", location)  # Debug
