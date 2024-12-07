extends CharacterBody2D

var speed = -150.0  # Speed of vertical movement
var patrol_distance = 100.0  # Distance to patrol in pixels
var start_position = Vector2.ZERO  # Initial position

func _ready():
	start_position = global_position
	$AnimatedSprite2D.play("ball_bounce")  # Use this if you're using an AnimatedSprite2D node

func _physics_process(delta):
	# Vertical patrol logic
	global_position.y += speed * delta

	# Reverse direction when reaching patrol bounds
	if global_position.y < start_position.y - patrol_distance or global_position.y > start_position.y + patrol_distance:
		flip()

func flip():
	speed = -speed  # Reverse direction
	# Optionally, you can change the animation based on direction
	if speed < 0:
		$AnimatedSprite2D.play("ball_bounce")
	else:
		$AnimatedSprite2D.play("ball_bounce")
