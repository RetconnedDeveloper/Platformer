extends CharacterBody2D

@export var speed: float = 200.0
@export var gravity: float = 900.0
@export var normal_jump_velocity: float = 400.0
@export var max_jump_multiplier: float = 1.2  
@export var jump_apex_time: float = 0.3  #max time to hold jump for a higher jump
@export var camera: Camera2D 

var is_jumping: bool = false
var jump_timer: float = 0.0

func _physics_process(delta: float) -> void:
	var horizontal_input: float = Input.get_axis("left", "right")
	velocity.x = horizontal_input * speed

	#gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	#Jump start
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		is_jumping = true
		jump_timer = 0.0
		velocity.y = -normal_jump_velocity

	#jump extension the longer u press jump
	if is_jumping and Input.is_action_pressed("jump"):
		jump_timer += delta
		if jump_timer < jump_apex_time:
			var jump_progress = jump_timer / jump_apex_time
			velocity.y = -lerp(normal_jump_velocity, normal_jump_velocity * max_jump_multiplier, jump_progress)
		else:
			is_jumping = false
	else:
		is_jumping = false

	move_and_slide()

	#update camera position
	if camera:
		update_camera()

func update_camera() -> void:
	#camera sticks to the player
	camera.position = global_position
