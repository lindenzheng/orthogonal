extends RigidBody2D

@export var linkedBody: RigidBody2D
@export var id: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if linkedBody:
		print(self.name + " linked with " + linkedBody.name)  # Debug
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# Get the position of linkedBody and share everything but the y-axis
	
	if linkedBody:
		#position.x = linkedBody.position.x
		rotation = linkedBody.rotation
		if not self.is_in_group("pushed") and linkedBody.is_in_group("pushed"):
			#position.x = linkedBody.position.x
			linear_velocity = linkedBody.linear_velocity
			angular_velocity = linkedBody.angular_velocity
