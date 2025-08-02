extends Node3D

var target_rot: float
@export var hands_target: Node3D
@export var lerp_speed: float = 3.0

func _process(delta: float) -> void:
	global_transform = lerp(global_transform, hands_target.global_transform, lerp_speed	* delta)
