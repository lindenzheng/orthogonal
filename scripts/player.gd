extends CharacterBody2D

@export var controls: PlayerControls = null

const SPEED = 300.0
const PUSH_FORCE = 15.0
const MIN_PUSH_FORCE = 10.0
#const JUMP_VELOCITY = -400.0

func _ready():
	add_to_group("player")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed(controls.interact) and is_on_floor():
			print(self.name + " interacted") # Debug
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_action_strength(controls.move_right) - Input.get_action_strength(controls.move_left)
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	# Object Push Code
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c. get_collider() is RigidBody2D:
			var push_force = (PUSH_FORCE * velocity.length() / SPEED) + MIN_PUSH_FORCE
			c. get_collider(). apply_central_impulse(-c.get_normal() * push_force)
