extends CharacterBody2D

var speed = -500.0
var patrol_distance = 1600.0  # Distance to patrol in pixels
var start_position = Vector2.ZERO  # Initial position

func _ready():
	start_position = global_position
	$AnimatedSprite2D.play("moving_left")  # Use this if you're using AnimatedSprite2D node

func _physics_process(delta):
	# Patrol logic
	global_position.x += speed * delta

	# Reverse direction when reaching patrol bounds
	if global_position.x < start_position.x - patrol_distance or global_position.x > start_position.x + patrol_distance:
		flip()

func flip():
	speed = -speed
	scale.x *= -1  # Flip the sprite

		
