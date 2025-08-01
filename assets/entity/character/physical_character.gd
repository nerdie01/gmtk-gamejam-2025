class_name PhysicalCharacter extends CharacterBody3D

var input: Vector2
var is_jumping: bool
var is_sprinting: bool

@export var velocity_component: EntityVelocityComponent

func _physics_process(delta: float) -> void:
	is_sprinting = is_sprinting && velocity != Vector3.ZERO

	velocity_component.move_relative(input, delta, rotation.y, is_sprinting)
	velocity_component.jump(is_on_floor() && is_jumping, delta)
	velocity = velocity_component.velocity
	move_and_slide()

func _unhandled_input(_event: InputEvent) -> void:
	input = Vector2(Input.get_axis("player_move_left", "player_move_right"), Input.get_axis("player_move_forward", "player_move_back"))
	is_jumping = Input.is_action_just_pressed("player_move_jump")
	is_sprinting = Input.is_action_pressed("player_move_sprint")