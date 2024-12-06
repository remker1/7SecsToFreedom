extends CanvasLayer

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


var total_resets = 0
const SAVE_FILE = "user://save_data.txt"

func _ready() -> void:
	load_reset_count()
	update_total_times_played_label()
	main_menu.show()
	game_over_menu.hide()
	pulse_menu.hide()
	map_menu.hide()
	get_tree().paused = true
	
	map_menu_button.get_popup().connect("id_pressed", _on_map_menu_item_pressed)

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
	print(total_times_played_count.text)
	total_times_played_count.text = "Total Times Played: %d" % total_resets

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
			print(total_resets)
		file.close()

func _on_start_pressed() -> void:
	load_reset_count()
	game_scene = LEVEL_0.instantiate()
	get_parent().add_child(game_scene)
	total_resets += 1
	update_total_times_played_label()
	save_reset_count()
	main_menu.hide()
	get_tree().paused = false

func _on_levels_pressed() -> void:
	map_menu.show()

func _on_exit_pressed() -> void:
	clear_save_file()
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
	load_reset_count()
	print("level 0")
	game_scene = LEVEL_0.instantiate()
	get_parent().add_child(game_scene)
	total_resets += 1
	save_reset_count()
	update_total_times_played_label()
	map_menu.hide()
	main_menu.hide()
	
func _on_level_1_button_pressed() -> void:
	load_reset_count()
	print("level 1")
	game_scene = LEVEL_1.instantiate()
	get_parent().add_child(game_scene)
	total_resets += 1
	save_reset_count()
	update_total_times_played_label()
	map_menu.hide()
	main_menu.hide()

func _on_level_2_button_pressed() -> void:
	load_reset_count()
	print("level 2")
	game_scene = LEVEL_2.instantiate()
	get_parent().add_child(game_scene)
	total_resets += 1
	save_reset_count()
	update_total_times_played_label()
	map_menu.hide()
	main_menu.hide()

func _on_level_3_button_pressed() -> void:
	load_reset_count()
	print("level 3")
	game_scene = LEVEL_3.instantiate()
	get_parent().add_child(game_scene)
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
