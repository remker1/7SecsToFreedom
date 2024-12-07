extends RigidBody2D

var random_speed
var direction = Vector2()

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	
	var window_size = get_viewport().size
	var window_center = Vector2(window_size / 2)
	
	randomize()  # Initialize random seeds
	var random_rotation_speed = randf_range(1, 5)
	random_speed = randf_range(1, 50) * 10
	
	# Define random position outside the screen
	var spawn_position = random_spawn_outside_viewport(window_size)
	position = spawn_position
	
	# Calculate direction to move toward the center
	direction = (window_center - position).normalized()
	
	# Set the linear velocity based on direction and speed
	linear_velocity = direction * random_speed
	
	# Set random rotation speed for asteroid
	angular_velocity = random_rotation_speed

# Physics process handles movement for RigidBody2D objects
func _physics_process(delta: float) -> void:
	# Physics-related updates, if needed (e.g., friction or extra movement handling)
	pass

# Define random spawn position outside the viewport
func random_spawn_outside_viewport(viewport_size):
	var margin = 100  # Distance outside the screen to spawn objects

	# Randomly choose one of the 4 regions (left, right, top, bottom)
	match randi() % 4:
		0:  # Left of the screen
			return Vector2(-margin, randf_range(0, viewport_size.y))
		1:  # Right of the screen
			return Vector2(viewport_size.x + margin, randf_range(0, viewport_size.y))
		2:  # Above the screen
			return Vector2(randf_range(0, viewport_size.x), -margin)
		3:  # Below the screen
			return Vector2(randf_range(0, viewport_size.x), -margin)

func _on_body_entered(body: Node) -> void:
	queue_free()

func wait_for_seconds(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
