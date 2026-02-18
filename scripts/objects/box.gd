extends RigidBody2D

signal pushed_object

@export var linkedBody: RigidBody2D
@export var id = 0

@onready var collision_shape = $CollisionShape2D

var last_pushed_object

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if id == 0:
		self.visible = true
		collision_mask = 1  # Collision with everything
		collision_layer = 1  # All other objects have collision
	else:
		self.visible = false
		collision_mask = 2  # Collision with the floor only
		collision_layer = 2  # Layer 1 objects don't have collision (Other objects don't have collision except layer 2)

	#if linkedBody:
		#print(self.name + " linked with " + linkedBody.name)  # Debug

func _on_in_intersection(area):
	print(self.name, " entered intersection ", area.name)
	if not last_pushed_object == id:
		self.visible = true
		collision_mask = 1 # Reset collision mask to collide with everything
		collision_layer = 1

func _on_out_intersection(area):
	print(self.name, " exited intersection ", area.name)
	if not last_pushed_object == id:
		self.visible = false
		collision_mask = 2 # Set to collide with the floor only
		collision_layer = 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# Code for linked boxes for intersections
	if linkedBody:
		# Set last pushed object if being pushed under condition
		if self.is_in_group("pushed") and not linkedBody.is_in_group("pushed"):
			emit_signal("pushed_object", id)
			last_pushed_object = id

		# Physics for linked boxes
		angular_velocity = 0
		if not self.is_in_group("pushed") and linkedBody.is_in_group("pushed"):
			linear_velocity = linkedBody.linear_velocity

func _on_pushed_object(pushedId):
	last_pushed_object = pushedId
