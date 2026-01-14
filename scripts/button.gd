extends Area2D

# Called when the node enters the area
func _on_Button_body_entered(body):
	if body.name == "Player1" || body.name == "Player2":
		print(body.name + " touched the button!")
		# Action!
