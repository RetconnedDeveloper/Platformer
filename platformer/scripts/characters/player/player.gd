class_name Player
extends CharacterBody2D

@export var move_speed: float = 200.0
@export var gravity: float = 900.0
@export var max_jump_power: float = 1000.0
@export var min_jump_power: float = 300.0
@export var power_oscillation_speed: float = 2.0 # how fast the bar in the arrow fills
@export var arrow_swing_speed: float = 1.5 # arrow pendulum speed
@export var arrow_swing_angle: int = 90  #degrees
@export var camera: Camera2D 

var is_throwing: bool = false
var is_aiming: bool = false
var is_charging: bool = false
var power_direction := 1 # 1:increasing, -1: decreasing

var jump_timer: float = 0.0

signal direction_changed(direction : float)

var direction : float :
	set(value):
		if direction == value:
			return
			
		direction = value
		direction_changed.emit(direction)

func _physics_process(delta: float) -> void:
	# gravity
	if !is_throwing:
		handle_movement(delta)

	#update camera position
	if camera:
		update_camera()
		
func handle_movement(delta):
	direction = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	velocity.x = direction * move_speed
	velocity.y += 500 * delta # gravity
	move_and_slide()

func update_camera() -> void:
	#camera sticks to the player
	camera.position = global_position
