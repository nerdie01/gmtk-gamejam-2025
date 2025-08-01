class_name FPVCamera extends Node

@export var camera: Camera3D
@export var target: PhysicsBody3D

@export_group("Parameters")
@export var camera_lerp_speed = 20.0
@export var sensitivity = 0.3
@export var offset: Vector3 = Vector3.UP

@export_group("Debug")
@export var debug_hide_mouse: bool = false

func _ready() -> void:
	if debug_hide_mouse:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _process(delta: float) -> void:
	camera.position = camera.position.lerp(target.position + offset, camera_lerp_speed * delta)
	camera.rotation.y = target.rotation.y

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		camera.global_rotation.x = clampf(camera.global_rotation.x - event.relative.y * sensitivity, -PI/2, PI/2)
		target.rotate_y(-event.relative.x * sensitivity)
		camera.orthonormalize()
