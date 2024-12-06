extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var animation = $AnimatedSprite2D
@onready var sfx_jump = $sfx_jump
@onready var sfx_waterswoosh: AudioStreamPlayer2D = $sfx_waterswoosh
@onready var death_noise: AudioStreamPlayer2D = $death_noise

var has_played_death_noise = false

func _handle_fall_death(): # Wait for the sound to finish
	get_tree().reload_current_scene()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

		if velocity.y >= 700:
			animation.hide()
			if not has_played_death_noise:  # Play sound only if it hasn't been played
				death_noise.play(0.05)
				has_played_death_noise = true
			await get_tree().create_timer(1).timeout
			call_deferred("_handle_fall_death")  # Defer handling the death to avoid physics interruptions
	else:
		has_played_death_noise = false  # Reset the flag when on the floor again

	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		animation.play("FishJump")
		sfx_jump.play()

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction > 0:
		animation.flip_h = false
	elif direction < 0:
		animation.flip_h = true

	if direction == 0:
		animation.play("FishIdle")
	else:
		animation.play("FishSwim")

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	# Wall collision sound handling
	if is_on_wall():
		if not sfx_waterswoosh.playing:
			sfx_waterswoosh.play(0.50)
	else:
		sfx_waterswoosh.stop()
