extends RigidBody3D

var orig_pos: Vector3
var is_open: bool = false

@export var area: Area3D

func _enter_tree() -> void:
	#SignalBus.interact.connect(_on_interact)
	area.body_entered.connect(_on_body_entered)
	orig_pos = global_position

#func _on_interact(body: PhysicsBody3D) -> void:
	#if body == self:
		#apply_impulse(Vector3.FORWARD)
		#if !is_open:
			#is_open = true
			#SignalBus.door_opened.emit(orig_pos)
		#return
		#
		#apply_impulse(Vector3.LEFT * 0.5)
		#is_open = false


func _on_body_entered(body: Node) -> void:
	if body is PhysicalCharacter:
		apply_impulse(body.velocity)
