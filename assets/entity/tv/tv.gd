class_name TV extends Node3D

@export var viewport_tex: ViewportTexture
@export var sprite: Sprite3D

func _ready() -> void:
	print(viewport_tex.viewport_path)
	sprite.texture = viewport_tex
