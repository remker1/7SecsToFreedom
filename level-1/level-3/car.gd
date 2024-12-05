extends CharacterBody2D

var speed = -500.0
var patrol_distance = 1600.0  # Distance to patrol in pixels
var start_position = Vector2.ZERO  # Initial position

@onready var car_sound: AudioStreamPlayer2D = $AudioStreamPlayer2D  # Reference to the car sound node

func _ready():
	start_position = global_position
	$AnimatedSprite2D.play("moving_left")  # Start playing the animation
	if car_sound:  # Ensure the sound node exists
		car_sound.play()  # Play the car sound

func _physics_process(delta):
	# Patrol logic
	global_position.x += speed * delta

	# Reverse direction when reaching patrol bounds
	if global_position.x < start_position.x - patrol_distance or global_position.x > start_position.x + patrol_distance:
		flip()

func flip():
	speed = -speed
	scale.x *= -1  # Flip the sprite

	# Reverse animation and sound (optional, if you want the sound to change direction)
	if car_sound:
		car_sound.play()  # Restart the sound

func _exit_tree():
	if car_sound:
		car_sound.stop()  # Stop the car sound when the car is removed
