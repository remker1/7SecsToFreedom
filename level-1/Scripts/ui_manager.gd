extends CanvasLayer

const GAME_SCENE = preload("res://Scenes/game_scene.tscn")
var game_scene : Node2D
@onready var main_menu: Control = $MainMenu
@onready var pulse_menu: Control = $PulseMenu
@onready var game_over_menu: Control = $GameOverMenu
@onready var time: Label = $GameOverMenu/Panel/Time

var starttime

func _ready() -> void:
	main_menu.show()
	game_over_menu.hide()
	pulse_menu.hide()
	get_tree().paused = true
	

func _on_start_pressed() -> void:
	game_scene = GAME_SCENE.instantiate()
	get_parent().add_child(game_scene)
	game_scene.game_over.connect(_on_game_scene_game_over)
	main_menu.hide()
	get_tree().paused = false
	starttime = Time.get_unix_time_from_system()


func _on_exit_pressed() -> void:
	get_tree().quit()



func _on_continue_pressed() -> void:
	pulse_menu.hide()


func _on_main_page_pressed() -> void:
	main_menu.show()
	pulse_menu.hide()
	game_scene.queue_free()


func _on_pulse_exit_pressed() -> void:
	get_tree().quit()
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ESC") && !main_menu.visible :
		pulse_menu.visible = !pulse_menu.visible
	if main_menu.visible || pulse_menu.visible || game_over_menu.visible:
		get_tree().paused = true
	else:
		get_tree().paused = false


func _on_over_back_main_pressed() -> void:
	game_over_menu.hide()
	main_menu.show()
	game_scene.queue_free()


func _on_over_exit_pressed() -> void:
	get_tree().quit()

func _on_game_scene_game_over() -> void:
	game_over_menu.show()
	var endtime = Time.get_unix_time_from_system()
	var timetaken = endtime - starttime
	var datetime = Time.get_datetime_dict_from_unix_time(timetaken)
	time.text = "Time Taken: "+str(datetime["hour"])+" : "+str(datetime["minute"])+" : " + str(datetime["second"])
	game_scene.queue_free()
	
