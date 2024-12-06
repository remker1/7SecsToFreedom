class_name Missile extends Node2D

@onready var portal: Area2D = $Portal
@onready var missiles = $Missiles
@onready var FishBowl = $FishBowl
@onready var death_noise: AudioStreamPlayer2D = $FishBowl/death_noise
@onready var Spikes = $Spikes
var spawn_timer = 0.0 

var level_progress
const PROGRESS_FILE = "user://level_progress.txt"

var missile_scene = preload("res://Scenes/missile.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for missile in missiles.get_children():
		missile.connect("respawn", _spawn_missile)
		missile.connect("player_body_hit", _on_play_death_sound)
		portal.connect("player_won",_on_player_won)
	
	for spike in Spikes.get_children():
		spike.connect("player_body_hit", _on_play_death_sound)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# spawns the missiles	
func _spawn_missile(pos, direction, rotation_angle):
	var new_missile = missile_scene.instantiate()
	var spawn_x = randf_range(1127, 1150) 
	var spawn_y = randf_range(0, 100)     
	new_missile.global_position = Vector2(spawn_x, spawn_y)
	# Calculate direction toward the player (FishBowl) AFTER setting position
	var new_direction = (FishBowl.global_position - new_missile.global_position).normalized()	
	# Assign the direction to the movement vector
	new_missile.movement_vector = new_direction
	# Align the missile's rotation with its direction
	new_missile.rotation = rotation
	call_deferred("add_child",new_missile)

	new_missile.connect("respawn", _spawn_missile)
	new_missile.connect("player_body_hit", _on_play_death_sound)
	
# function to play death sound when fish dies
func _on_play_death_sound():
	if FishBowl:
		FishBowl.set_process(false) # stops all movement of the fish
		FishBowl.set_physics_process(false)  
		FishBowl.hide()  # Hides the fish
	
	death_noise.play()
	await get_tree().create_timer(0.5).timeout	
	call_deferred("reload_scene")
# reloads the current scene.
func reload_scene():
	if get_tree():  # Ensure the scene tree still exists
		get_tree().reload_current_scene()

func _on_player_won() -> void:
	print("Player Won")
	load_level_progress()
	level_progress += 1
	save_level_progress()
	get_tree().reload_current_scene()


func load_level_progress() -> void:
	if FileAccess.file_exists(PROGRESS_FILE):
		var file = FileAccess.open(PROGRESS_FILE, FileAccess.READ)
		if file:
			if not file.eof_reached():
				level_progress = int(file.get_line())
				print("Loaded level progress:", level_progress)
			file.close()
	else:
		print("No progress file found. Defaulting to initial levels.")
		level_progress = 1  # Default to level 0 and 1 unlocked


func save_level_progress() -> void:
	var file = FileAccess.open(PROGRESS_FILE, FileAccess.WRITE)
	if file:
		file.store_line(str(level_progress))
		print("Saved level progress:", level_progress)
		file.close()
	else:
		print("Failed to open progress file for saving.")
