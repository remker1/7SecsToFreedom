extends Node2D

const SPEED = 150.0  # Speed of the car
@export var spawn_interval: float = 2.0  # Time between car spawns

var car_scene: PackedScene  # Reference to the car scene
var timer = 0.0  # Timer for spawning

func _ready() -> void:
	# Load the car scene dynamically (do not drag it into the main scene)
	car_scene = load("res://level-3/car.tscn")  # Replace with the actual path to your car.tscn file
	if car_scene == null:
		print("Failed to load car.tscn!")  # Print error message if loading fails
		return

func _process(delta: float) -> void:
	# Handle spawning of new cars
	timer += delta
	if timer >= spawn_interval:
		spawn_car()
		timer = 0.0  # Reset timer

func spawn_car() -> void:
	if car_scene:
		var new_car = car_scene.instantiate()
		get_parent().add_child(new_car)  # Add the new car to the same parent as this script

		# Determine spawn direction and position
		var spawn_direction = Vector2.RIGHT if randf() < 0.5 else Vector2.LEFT
		new_car.position = Vector2(
			-50 if spawn_direction == Vector2.RIGHT else get_viewport_rect().size.x + 50,
			randf_range(50, get_viewport_rect().size.y - 50)  # Random vertical position
		)
		new_car.direction = spawn_direction  # Set the movement direction for the new car
