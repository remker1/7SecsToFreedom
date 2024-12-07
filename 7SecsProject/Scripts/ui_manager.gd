extends CanvasLayer
class_name MainUICanvasLayer

const LEVEL_0 = preload("res://Scenes/level_0_game_scene.tscn")
const LEVEL_1 = preload("res://Scenes/level_1_livingroom.tscn")
const LEVEL_2 = preload("res://Scenes/level_backyard.tscn")
const LEVEL_3 = preload("res://level-3/level_3_game_scene.tscn")


var game_scene : Node2D
@onready var main_menu: Control = $MainMenu
@onready var pulse_menu: Control = $PulseMenu
@onready var game_over_menu: Control = $GameOverMenu
@onready var map_menu: Control = $MapMenu
@onready var map_menu_button: MenuButton = $MapMenu/MapMenuButton
@onready var total_times_played_count: Label = $MapMenu/TotalTimesPlayedCount

@onready var final_scene_button: TextureButton = $"MapMenu/Final Scene Button"
@onready var level_3_button: TextureButton = $"MapMenu/Level 3 Button"
@onready var level_2_button: TextureButton = $"MapMenu/Level 2 Button"
@onready var level_1_button: TextureButton = $"MapMenu/Level 1 Button"
@onready var level_0_button: TextureButton = $"MapMenu/Level 0 Button"
@onready var f_inished_in_tries: Label = $GameOverMenu/Panel/CenterContainer/VBoxContainer/FInishedInTries



var total_resets = 0
var level_progress = 1
const SAVE_FILE = "user://save_data.txt"
const PROGRESS_FILE = "user://level_progress.txt"

# static var is_reload : int = -1
# static var current_level : int = 0

func _ready() -> void:
	load_level_progress()
	update_level_buttons()
	load_reset_count()
	update_total_times_played_label()
	main_menu.show()
	game_over_menu.hide()
	pulse_menu.hide()
	map_menu.hide()
	get_tree().paused = true
	
	map_menu_button.get_popup().connect("id_pressed", _on_map_menu_item_pressed)
	
''' dont have enough time to implement
	if is_reload != -1 :
		print(is_reload)
		if is_reload == 0:
			call_deferred("_on_level_0_button_pressed")	
			is_reload = false
			
		if is_reload == 1:
			call_deferred("_on_level_1_button_pressed()")
			is_reload = false
		
		if is_reload == 2:
			call_deferred("_on_level_2_button_pressed()")
			is_reload = false
		
		if is_reload == 3:
			call_deferred("_on_level_3_button_pressed()")
			is_reload = false
'''		

func clear_progress_file() -> void:
	if FileAccess.file_exists(PROGRESS_FILE):
		var file = FileAccess.open(PROGRESS_FILE, FileAccess.WRITE)
		if file:
			file.store_string("")  # Overwrite the file with an empty string
			print("Save file contents cleared:", PROGRESS_FILE)
			file.close()
		else:
			print("Failed to open save file for clearing:", PROGRESS_FILE)
	else:
		print("No save file to clear.")

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

func clear_save_file() -> void:
	if FileAccess.file_exists(SAVE_FILE):
		var file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
		if file:
			file.store_string("")  # Overwrite the file with an empty string
			print("Save file contents cleared:", SAVE_FILE)
			file.close()
		else:
			print("Failed to open save file for clearing:", SAVE_FILE)
	else:
		print("No save file to clear.")

func update_total_times_played_label() -> void:
	total_times_played_count.text = "Total Times Played: %d" % total_resets
	f_inished_in_tries.text = "You have finished the game in %d tries!" % total_resets

func save_reset_count() -> void:
	var file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	if file:
		file.store_line(str(total_resets))
		print("Saved total_resets:", total_resets)
		file.close()
	else:
		print("Failed to open file for writing.")

func load_reset_count() -> void:
	var file = FileAccess.open(SAVE_FILE, FileAccess.READ)
	if file:
		if not file.eof_reached():
			total_resets = int(file.get_line())
		file.close()

func _on_start_pressed() -> void:
	load_reset_count()
	print("--------------------------------")
	print("level 0")
	game_scene = LEVEL_0.instantiate()
	get_parent().add_child(game_scene)
	main_menu.hide()
	get_tree().paused = false

func _on_levels_pressed() -> void:
	map_menu.show()

func _on_exit_pressed() -> void:
	clear_save_file()
	clear_progress_file()
	get_tree().quit()

func _on_continue_pressed() -> void:
	pulse_menu.hide()

func _on_main_page_pressed() -> void:
	main_menu.show()
	pulse_menu.hide()
	map_menu.hide()
	game_scene.queue_free()

func _on_pulse_exit_pressed() -> void:
	clear_save_file()
	clear_progress_file()
	get_tree().quit()

func _on_map_pressed() -> void:
	map_menu.show()
	main_menu.hide()
	pulse_menu.hide()
	game_scene.queue_free()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Quit") && !main_menu.visible :
		pulse_menu.visible = !pulse_menu.visible
	if main_menu.visible || pulse_menu.visible || game_over_menu.visible || map_menu.visible:
		get_tree().paused = true
	else:
		get_tree().paused = false

func _on_over_back_main_pressed() -> void:
	game_over_menu.hide()
	map_menu.hide()
	main_menu.show()

func _on_over_exit_pressed() -> void:
	clear_progress_file()
	clear_save_file()
	get_tree().quit()

func _on_game_scene_game_over() -> void:
	game_over_menu.show()
	game_scene.queue_free()
	
func _on_final_scene_button_pressed() -> void:
	map_menu.hide()
	main_menu.hide()
	game_over_menu.show()
	
func _on_level_0_button_pressed() -> void:

	print("--------------------------------")
	print("level 0")
	game_scene = LEVEL_0.instantiate()
	get_parent().add_child(game_scene)
	# current_level = 0
	map_menu.hide()
	main_menu.hide()
	
func _on_level_1_button_pressed() -> void:
	load_reset_count()
	print("--------------------------------")
	print("level 1")
	game_scene = LEVEL_1.instantiate()
	get_parent().add_child(game_scene)
	# current_level = 1
	total_resets += 1
	save_reset_count()
	update_total_times_played_label()
	map_menu.hide()
	main_menu.hide()

func _on_level_2_button_pressed() -> void:
	load_reset_count()
	print("--------------------------------")
	print("level 2")
	game_scene = LEVEL_2.instantiate()
	get_parent().add_child(game_scene)
	# current_level = 2
	total_resets += 1
	save_reset_count()
	update_total_times_played_label()
	map_menu.hide()
	main_menu.hide()

func _on_level_3_button_pressed() -> void:
	load_reset_count()
	print("--------------------------------")
	print("level 3")
	game_scene = LEVEL_3.instantiate()
	get_parent().add_child(game_scene)
	# current_level = 3
	total_resets += 1
	save_reset_count()
	update_total_times_played_label()
	map_menu.hide()
	main_menu.hide()

func _on_map_menu_item_pressed(id: int) -> void:
	match id:
		0:
			_on_over_back_main_pressed()
		1:
			_on_exit_pressed()


func update_level_buttons() -> void:
	level_0_button.disabled = false  # Level 0 is always unlocked
	level_1_button.disabled = false  # Level 1 is always unlocked
	level_2_button.disabled = level_progress < 2
	level_3_button.disabled = level_progress < 3
	final_scene_button.disabled = level_progress < 4
