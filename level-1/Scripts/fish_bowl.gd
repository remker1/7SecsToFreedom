extends CharacterBody2D

@onready var collide_2: TileMapLayer = $"../Collide-2"

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var animation = $AnimatedSprite2D
@onready var sfx_jump = $sfx_jump
@onready var sfx_waterswoosh: AudioStreamPlayer2D = $sfx_waterswoosh


func _physics_process(delta: float) -> void:
	# Add the gravity.
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		if velocity.y >= 600:
			# Death animation still in progress, Console Message as replacement.
			print("Die Animation")
			get_tree().reload_current_scene()
			

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		animation.play("FishJump")
		sfx_jump.play()
		 

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	
	if direction > 0:
		animation.flip_h = false
	elif direction < 0:
		animation.flip_h = true
	
	if direction == 0 :
		animation.play("FishIdle")
	else:
		animation.play("FishSwim")
	
	if direction:
		velocity.x = direction * SPEED

	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		

	move_and_slide()
	
# currently not working as expected. Should playu a sound if we hit a wall but only once, it does it many times.
	if is_on_wall():		
			if not sfx_waterswoosh.playing:				
					sfx_waterswoosh.play(0.50)
	else:
			sfx_waterswoosh.stop()

	
	
	
