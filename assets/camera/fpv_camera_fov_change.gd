class_name FPVCameraFOVChange extends Node

var camera: Camera3D

var default_fov: float
var target_fov: float

var lerp_speed: float
var target: PhysicalCharacter

@export var first_person_camera: FPVCamera
@export var sprint_fov_multiplier: float = 1.25
@export var fov_lerp_speed: float = 5.0

func _ready() -> void:
    camera = first_person_camera.camera
    default_fov = camera.fov
    lerp_speed = first_person_camera.camera_lerp_speed
    if first_person_camera.target is PhysicalCharacter:
        target = first_person_camera.target
        return

    push_error("FirstPersonCameraFOVChange requires a PhysicalCharacter target for the camera")

func _process(delta: float) -> void:
    if target.is_sprinting:
        target_fov = default_fov * sprint_fov_multiplier
    else:
        target_fov = default_fov

    camera.fov = lerpf(camera.fov, target_fov, fov_lerp_speed * delta)