class_name PlayerInput
extends Node

@export var player : Player
@export var actions : PlayerInputActions

func _process(delta: float) -> void:
	player.direction = Input.get_axis(actions.left, actions.right)
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(actions.jump):
		player.try_jump()
