extends Node2D

@onready var portal: Area2D = $Portal

var level_progress
const PROGRESS_FILE = "user://level_progress.txt"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_level_progress()
	portal.player_won.connect(_on_player_won)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_player_won() -> void:
	print("Player Won")
	load_level_progress()
	level_progress += 2
	save_level_progress()
	# MainUICanvasLayer.is_reload = 2
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
