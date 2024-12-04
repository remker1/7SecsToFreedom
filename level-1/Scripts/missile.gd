extends Area2D

signal player_body_hit
signal respawn(pos, direction, rotation_angle)		
var movement_vector := Vector2(0,-1)

@export var speed := 0
@export var size := 50
@export var spin_speed := randf_range(5.0, 50.0)
@onready var sprite := $Sprite2D
@onready var time = $Timer
@onready var shuriken_collision: AudioStreamPlayer2D = $"shuriken-collision"


func _ready() -> void:
	shuriken_collision.play()
	speed = randf_range(300,600) # speed of the missile (aka shuriken but i made this change last second so i didnt bother changing all the missiles name to shuriken)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	global_position += movement_vector.rotated(rotation) * speed * delta 
	sprite.rotation += spin_speed * delta # rotation


func _on_body_entered(body: Node2D) -> void:
	# shuriken colliding with the fish
	if body is CharacterBody2D:	
		emit_signal("player_body_hit")		
	else: # shuriken colliding with a tilemap
		emit_signal("respawn", global_position, movement_vector, rotation) 
		queue_free()
