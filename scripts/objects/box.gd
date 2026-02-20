extends RigidBody2D

signal pushed_object

@export var linkedBody: RigidBody2D
@export var priority = 0
var last_pushed_object

func _ready() -> void:
	if priority == 0:
		self.visible = true
		collision_mask = 1  # Collision with everything
		collision_layer = 1  # All other objects have collision
	else:
		self.visible = false
		collision_mask = 2  # Collision with the floor only
		collision_layer = 2  # Layer 1 objects don't have collision (Other objects don't have collision except layer 2)
		#last_pushed_object = linkedBody

func _on_in_intersection(area):
	print(self.name, " entered intersection ", area.name)
	if not last_pushed_object == linkedBody:
		self.visible = true
		collision_mask = 1 # Reset collision mask to collide with everything
		collision_layer = 1

func _on_out_intersection(area):
	print(self.name, " exited intersection ", area.name)
	if not last_pushed_object == linkedBody:
		self.visible = false
		collision_mask = 2 # Set to collide with the floor only
		collision_layer = 2

func _process(_delta: float) -> void:
	angular_velocity = 0 # Prevent box rotations
	
	# Code for linked boxes for intersections
	if linkedBody:
		if self.is_in_group("pushed") and not linkedBody.is_in_group("pushed"):
			emit_signal("pushed_object", linkedBody) # Sync last_pushed_object with _on_pushed_object() function
			last_pushed_object = linkedBody
		else: if not self.is_in_group("pushed") and linkedBody.is_in_group("pushed"):  # Sync box position
			linear_velocity = linkedBody.linear_velocity
			self.position.x = linkedBody.position.x
		#else: if (not self.is_in_group("pushed") and not linkedBody.is_in_group("pushed")) and priority == 1:
			#pass
			#self.position.x = linkedBody.position.x
		else: if self.is_in_group("pushed") and linkedBody.is_in_group("pushed"):  # Stop box movement
			linear_velocity = Vector2(0, 0)
			self.position.x = self.position.x

func _on_pushed_object(linkedBody):
	last_pushed_object = linkedBody
