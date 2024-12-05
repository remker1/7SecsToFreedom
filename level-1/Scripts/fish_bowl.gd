extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -400.0
@onready var animation = $AnimatedSprite2D
@onready var sfx_jump = $sfx_jump
@onready var sfx_waterswoosh: AudioStreamPlayer2D = $sfx_waterswoosh
@onready var death_noise: AudioStreamPlayer2D = $death_noise
var spawn_time = 0.0

var is_dead = false  # Tracks if the player is already dead

@export var next_level_scene: String = "res://Scenes/level_0_game_scene.tscn"

func _physics_process(delta: float) -> void:
	if is_dead:  # If the player is dead, skip further processing
		return

	# Add gravity
	if not is_on_floor():
		velocity += get_gravity() * delta	
		if velocity.y >= 600:
			die()

	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		animation.play("FishJump")
		sfx_jump.play()

	# Handle movement
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction > 0:
		animation.flip_h = false
	elif direction < 0:
		animation.flip_h = true
	
	if direction == 0:
		animation.play("FishIdle")
	else:
		animation.play("FishSwim")
	
	velocity.x = direction * SPEED if direction != 0 else move_toward(velocity.x, 0, SPEED)

	# Move and check collisions
	move_and_slide()
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider and not is_dead:  # Only process collision if player is alive
			if collider.name == "cat":
				die()
				print("Got hit by a cat")
			elif collider.name == "car":
				die()
				print("Got hit by a car")
			elif collider.name == "ball":
				print("Got hit by a ball")
				die()

	# Wall collision sound
	if is_on_wall():		
		if not sfx_waterswoosh.playing:				
			sfx_waterswoosh.play(0.50)
	else:
		sfx_waterswoosh.stop()
		
	# Check if player reaches the end of the screen
	if global_position.x >= get_viewport_rect().size.x:
		switch_to_next_scene()

func die():
	if is_dead:  # Prevent multiple calls to die()
		return
	is_dead = true  # Mark player as dead
	animation.set_process(false)
	animation.set_physics_process(false)
	animation.hide()

	death_noise.play(0.05)
	await get_tree().create_timer(0.04).timeout
	call_deferred("reload_scene")
		
func switch_to_next_scene() -> void:
	if next_level_scene != "":
		print("Switching to the next level...")
		get_tree().change_scene_to_file(next_level_scene)
	else:
		print("Next level scene is not set!")
		
func reload_scene():
	if get_tree():
		get_tree().reload_current_scene()
