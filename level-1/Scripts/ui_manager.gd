extends CanvasLayer

const LEVEL_0 = preload("res://Scenes/level_0_game_scene.tscn")
const LEVEL_1 = preload("res://Scenes/level_0_game_scene.tscn")
const LEVEL_2 = preload("res://Scenes/level_0_game_scene.tscn")
const LEVEL_3 = preload("res://Scenes/level_0_game_scene.tscn")

var game_scene : Node2D
@onready var main_menu: Control = $MainMenu
@onready var pulse_menu: Control = $PulseMenu
@onready var game_over_menu: Control = $GameOverMenu
@onready var map_menu: Control = $MapMenu
@onready var map_menu_button: MenuButton = $MapMenu/MapMenuButton


func _ready() -> void:
	main_menu.show()
	game_over_menu.hide()
	pulse_menu.hide()
	map_menu.hide()
	get_tree().paused = true
	
	map_menu_button.get_popup().connect("id_pressed", _on_map_menu_item_pressed)

func _on_start_pressed() -> void:
	game_scene = LEVEL_0.instantiate()
	get_parent().add_child(game_scene)
	main_menu.hide()
	get_tree().paused = false

func _on_levels_pressed() -> void:
	map_menu.show()

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_continue_pressed() -> void:
	pulse_menu.hide()

func _on_main_page_pressed() -> void:
	main_menu.show()
	pulse_menu.hide()
	map_menu.hide()
	game_scene.queue_free()

func _on_pulse_exit_pressed() -> void:
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
	get_tree().quit()

func _on_game_scene_game_over() -> void:
	game_over_menu.show()
	game_scene.queue_free()
	
func _on_final_scene_button_pressed() -> void:
	map_menu.hide()
	main_menu.hide()
	game_over_menu.show()
	
func _on_level_0_button_pressed() -> void:
	print("level 0")
	game_scene = LEVEL_0.instantiate()
	get_parent().add_child(game_scene)
	map_menu.hide()
	main_menu.hide()
	
func _on_level_1_button_pressed() -> void:
	print("level 1")
	game_scene = LEVEL_1.instantiate()
	get_parent().add_child(game_scene)
	map_menu.hide()
	main_menu.hide()

func _on_level_2_button_pressed() -> void:
	print("level 2")
	game_scene = LEVEL_2.instantiate()
	get_parent().add_child(game_scene)
	map_menu.hide()
	main_menu.hide()

func _on_level_3_button_pressed() -> void:
	print("level 3")
	game_scene = LEVEL_3.instantiate()
	get_parent().add_child(game_scene)
	map_menu.hide()
	main_menu.hide()

func _on_map_menu_item_pressed(id: int) -> void:
	match id:
		0:
			_on_over_back_main_pressed()
		1:
			_on_exit_pressed()
			 
