extends Node2D

@export var car_scene: car.tscn  # Assign your car scene in the Inspector
@export var spawn_interval: float = 2.0  # Time between spawns
var _spawn_timer: Timer

func _ready() -> void:
	# Create a Timer to handle spawning
	_spawn_timer = Timer.new()
	_spawn_timer.wait_time = spawn_interval
	_spawn_timer.one_shot = false
	_spawn_timer.autostart = true
	add_child(_spawn_timer)
	_spawn_timer.start()
	_spawn_timer.timeout.connect(spawn_car)

func spawn_car() -> void:
	if not car_scene:
		print("Error: Car scene is not assigned.")
		return

	var car_instance = car_scene.instantiate()  # Create a new instance of the car
	add_child(car_instance)  # Add the car to the scene tree

	# Set the car's initial position and direction
	var viewport_rect = get_viewport_rect()

	if randf() < 0.5:
		# Spawn from the left
		car_instance.position = Vector2(-car_instance.sprite.texture.get_size().x, rand_range(0, viewport_rect.size.y))
	else:
		# Spawn from the right
		car_instance.position = Vector2(viewport_rect.size.x + car_instance.sprite.texture.get_size().x, rand_range(0, viewport_rect.size.y))

	print("Car spawned at position:", car_instance.position)
