extends Node2D

@onready var portal: Area2D = $Portal

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	portal.player_won.connect(_on_player_won)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_player_won() -> void:
	print("Player Won")
	 # MainUICanvasLayer.is_reload = 1
	get_tree().reload_current_scene()
