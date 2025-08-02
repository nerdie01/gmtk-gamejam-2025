class_name EntityInteractionComponent extends Node

var is_interaction_focused: bool = false

@export_group("Assign")
@export var character: PhysicalCharacter

@export_group("Parameters")
@export var interaction_range: float = 100;

func _physics_process(delta: float) -> void:
	var result: Dictionary = raycast_mouse()
	
	if !result.is_empty() && result != null:
		var body = result["collider"] as PhysicsBody3D

		for child in body.get_children():
			if child is Interactable && !is_interaction_focused:
				is_interaction_focused = true
				
				if Input.is_action_just_pressed("player_interact"):
					SignalBus.interact.emit(body)
					
			elif child is not Interactable && is_interaction_focused:
				is_interaction_focused = false

func raycast_mouse() -> Dictionary:
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var camera: Camera3D = get_viewport().get_camera_3d()
	
	var start = camera.project_ray_origin(mouse_pos)
	var end = camera.project_position(mouse_pos, interaction_range)
	
	var space_state: PhysicsDirectSpaceState3D = character.get_world_3d().direct_space_state
	var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(start, end)
	return space_state.intersect_ray(query)
