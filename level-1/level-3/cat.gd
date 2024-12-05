extends CharacterBody2D

var speed = 60.0
var patrol_distance = 100.0  # Distance to patrol in pixels
var start_position = Vector2.ZERO  # Initial position

@onready var cat_sound: AudioStreamPlayer2D = $AudioStreamPlayer2D  # Reference to the AudioStreamPlayer2D node

func _ready():
	start_position = global_position
	$AnimatedSprite2D.play("right")  # Start the animation
	if cat_sound:  # Ensure the sound node exists
		cat_sound.play()  # Play the cat sound

func _physics_process(delta):
	# Patrol logic
	global_position.x += speed * delta

	# Reverse direction when reaching patrol bounds
	if global_position.x < start_position.x - patrol_distance or global_position.x > start_position.x + patrol_distance:
		flip()

func flip():
	speed = -speed
	scale.x *= -1 # Flip the sprite

	# Restart cat sound when direction changes
	if cat_sound:
		cat_sound.play()
