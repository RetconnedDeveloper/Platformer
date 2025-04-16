class_name Player
extends CharacterBody2D

@onready var arrow_ui = $arrow_ui

@export var move_speed: float = 200.0
@export var gravity: float = 900.0
@export var max_throw_power: float = 1000.0
@export var min_throw_power: float = 300.0
@export var power_oscillation_speed: float = 250.0 # how fast the bar in the arrow fills
@export var arrow_swing_speed: float = 1.5 # arrow pendulum speed
@export var arrow_swing_angle: float = 0.0  #degrees
@export var camera: Camera2D 

var is_throwing: bool = false
var is_aiming: bool = false
var is_charging: bool = false
var power_direction := 1 # 1:increasing, -1: decreasing
var throw_power := 300.0

#var jump_timer: float = 0.0

signal direction_changed(direction : float)

var direction : float :
	set(value):
		if direction == value:
			return
			
		direction = value
		direction_changed.emit(direction)

func _physics_process(delta: float) -> void:
	# gravity
	if !is_aiming:
		handle_movement(delta)

	handle_input()
	update_arrow(delta)
	#update camera position
	if camera:
		update_camera()
		
func handle_movement(delta):
	direction = Input.get_axis("left", "right")
	velocity.x = direction * move_speed
	velocity.y += 500 * delta # gravity
	move_and_slide()
	
func handle_input():
	
	
		
	if Input.is_action_just_released("click") and !is_aiming:
		is_aiming = true
		is_charging = false
		arrow_swing_angle = 0
		arrow_ui.visible = true
		
	if is_aiming:
		if Input.is_action_just_pressed("click") and !is_throwing:
			is_charging = true
			print("charge")
	
		elif Input.is_action_just_released("click") and is_charging:
			is_charging = false
			is_throwing = true
			print("ball thrown")
		
func update_arrow(delta):
	if is_aiming and !is_charging and !is_throwing:
		arrow_swing_angle += arrow_swing_speed * delta
		var angle = sin(arrow_swing_angle)
		arrow_ui.rotation = angle
	elif is_charging:
		if power_direction == 1:
			throw_power += power_oscillation_speed * delta
			if throw_power >= max_throw_power:
				throw_power = max_throw_power
				power_direction = -1
		else:
			throw_power -= power_oscillation_speed * delta
			if throw_power <= min_throw_power:
				throw_power = min_throw_power
				power_direction = 1
		print(throw_power)

func update_camera() -> void:
	#camera sticks to the player
	camera.position = global_position
