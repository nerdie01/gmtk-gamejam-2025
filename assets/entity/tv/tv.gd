class_name TV extends Node3D

var current_vhs_index = 0

var vhs_keys: Dictionary[String, int] = {
	"vhs_1": 0,
	"vhs_2": 1,
	"vhs_3": 2,
	"vhs_4": 3,
	"vhs_5": 4,
	"vhs_6": 5,
	"vhs_7": 6,
	"vhs_8": 7,
	"vhs_9": 8
}

@export var viewport_tex: ViewportTexture
@export var sprite: Sprite3D
@export var anim_player: AnimationPlayer

func _ready() -> void:
	sprite.texture = viewport_tex

func _unhandled_input(event: InputEvent) -> void:
	for keystring: String in vhs_keys.keys():
		if Input.is_action_just_pressed(keystring) && current_vhs_index != vhs_keys[keystring]:
			current_vhs_index = vhs_keys[keystring]
			anim_player.play("tv_reload")
