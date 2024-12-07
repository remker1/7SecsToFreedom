extends Node2D

@export var spawn_interval: float = 2.0  # Time between car spawns
var timer = 0.0  # Timer to track spawn intervals
var car_scene: PackedScene  # Reference to the car scene
@onready var tilemap: TileMap = get_parent().get_node("ground")  # Reference to the TileMap node

func _ready() -> void:
	# Load the car scene dynamically
	car_scene = load("res://level-3/car.tscn")  # Ensure the path to your car.tscn is correct

func _process(delta: float) -> void:
	# Handle the spawn timer
	timer += delta
	if timer >= spawn_interval:
		spawn_car()
		timer = 0.0  # Reset the timer

func spawn_car() -> void:
	if car_scene:
		var new_car = car_scene.instantiate()  # Instantiate a new car from the car scene
		get_parent().add_child(new_car)  # Add the new car to the same parent as this spawner

		# Find a valid spawn position from the TileMap
		var spawn_position = get_valid_spawn_position()

		# Set the car's position to the valid spawn position
		new_car.position = spawn_position

		# Randomly decide the car's movement direction
		var spawn_direction = Vector2.RIGHT if randf() < 0.5 else Vector2.LEFT
		new_car.direction = spawn_direction  # Set the movement direction for the new car

# Function to find a valid spawn position on the TileMap
func get_valid_spawn_position() -> Vector2:
	if tilemap == null:
		print("Error: TileMap not found!")
		return Vector2.ZERO

	var tile_size = tilemap.cell_size
	var used_rect = tilemap.get_used_rect()

	# Iterate over the tiles in the TileMap to find a suitable spawn point
	for x in range(used_rect.position.x, used_rect.end.x):
		for y in range(used_rect.position.y, used_rect.end.y):
			# Check if the tile at (x, y) is a valid place to spawn the car
			if tilemap.get_cell(x, y) != -1:  # Assuming -1 means no tile
				# Return a spawn position on this tile
				return Vector2(x * tile_size.x, y * tile_size.y)

	# Fallback if no valid spawn is found
	return Vector2.ZERO
