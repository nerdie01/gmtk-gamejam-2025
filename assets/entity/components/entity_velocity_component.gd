class_name EntityVelocityComponent extends Node

var jump_target: float
var velocity: Vector3

@export var jump_force: float = 30
@export var jump_lerp_decay_rate: float = 5

@export var move_speed: float = 120
@export var sprint_speed: float = 180

func move(direction: Vector2, delta: float, is_sprinting: bool = false) -> Vector3:
	var normalized_direction = direction.normalized()
	if is_sprinting:
		velocity = Vector3(normalized_direction.x * sprint_speed, velocity.y, normalized_direction.y * sprint_speed) * delta
		return velocity

	velocity = Vector3(normalized_direction.x * move_speed, velocity.y, normalized_direction.y * move_speed) * delta
	return velocity

func move_relative(direction: Vector2, delta: float, theta: float, is_sprinting: bool = false, axis: Vector3 = Vector3.UP) -> Vector3:
	move(direction, delta, is_sprinting)
	velocity = velocity.rotated(axis, theta)
	return velocity

func jump(condition: bool, delta: float) -> void:
	if condition:
		jump_target = jump_force

	jump_target = lerp(jump_target, 0.0, jump_lerp_decay_rate * delta)
	velocity.y += -9.81 + jump_target
