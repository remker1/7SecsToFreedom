extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -400.0
@onready var animation = $AnimatedSprite2D
@onready var sfx_jump = $sfx_jump
@onready var sfx_waterswoosh: AudioStreamPlayer2D = $sfx_waterswoosh
@onready var death_noise: AudioStreamPlayer2D = $death_noise

var is_dead = false

func _physics_process(delta: float) -> void:
	if is_dead:
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
		if collision.get_collider().name == "cat":
			die()
		if collision.get_collider().name == "car":
			die()

	# Wall collision sound
	if is_on_wall():		
		if not sfx_waterswoosh.playing:				
			sfx_waterswoosh.play(0.50)
	else:
		sfx_waterswoosh.stop()

func die():
	print("Die Animation")
	death_noise.play()
	
	if is_instance_valid(self):
		await get_tree().create_timer(0.0).timeout
		
		if get_tree() != null:
			get_tree().reload_current_scene()
		else:
			print("Error: get_tree() is null after delay.")
	else:
		print("Error: Player instance is no longer valid.")
