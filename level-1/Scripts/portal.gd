extends Area2D

<<<<<<< HEAD
signal player_won

=======
>>>>>>> 66dc8204e56cce222f215587c9f9e84cc7477e36

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
<<<<<<< HEAD
	print("player won")
	emit_signal("player_won")
=======
	if body is CharacterBody2D:
		body.set_position($Destination.global_position)
	
>>>>>>> 66dc8204e56cce222f215587c9f9e84cc7477e36
