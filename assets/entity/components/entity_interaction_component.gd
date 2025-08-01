class_name EntityInteractionComponent extends Node

@export_group("Assign")
@export var character: PhysicalCharacter

@export_group("Parameters")
@export var max_raycast_distance: float = 100;

func _physics_process(delta: float) -> void:
	print(raycast_mouse())

func raycast_mouse() -> Dictionary:
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var camera: Camera3D = get_viewport().get_camera_3d()
	
	var start = camera.project_ray_origin(mouse_pos)
	var end = camera.project_position(mouse_pos, max_raycast_distance)
	
	var space_state: PhysicsDirectSpaceState3D = character.get_world_3d().direct_space_state
	var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(start, end)
	return space_state.intersect_ray(query)
