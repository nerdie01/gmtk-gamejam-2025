class_name RoomGenerator extends Node3D

var room_queue: Dictionary[Vector3i, StaticBody3D] = { }
var last_pos: int = -100

@export_group("Assign")
@export var player: PhysicalCharacter
@export var timer: Timer
@export var room: PackedScene

@export_group("Parameters")
@export var room_size: float = 8
@export var gen_direction: Vector3 = Vector3.BACK
@export var cull_rooms: int = 3

func _enter_tree() -> void:
	timer.timeout.connect(_on_regen_timer_timeout)

func clamped_to_room_center(pos: Vector3) -> int:
	return snapped(pos.dot(gen_direction), room_size)

func _on_regen_timer_timeout() -> void:
	var clamped_pos: int = clamped_to_room_center(player.position)
	if last_pos == clamped_pos:
		return
	
	for i in range(-cull_rooms * room_size + clamped_pos, cull_rooms * room_size + clamped_pos, room_size):
		if !room_queue.has(Vector3i(i * gen_direction)) && i != 0:
			var new_room: StaticBody3D = room.instantiate() as StaticBody3D
			new_room.position = gen_direction * i
			room_queue[Vector3i(i * gen_direction)] = new_room
			add_child(new_room)
			
	for i: int in range(len(room_queue.keys()) - 1):
		var room_pos: Vector3i = room_queue.keys()[i]
		if abs(clamped_pos - gen_direction.dot(room_pos)) > cull_rooms * room_size:
			room_queue[room_pos].queue_free()
			room_queue.erase(room_pos)
			i -= 1
			
	print(len(room_queue))
