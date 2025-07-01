extends StaticBody2D

@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D

func _ready():
	# Randomize platform size
	var scale_factor = randf_range(0.8, 1.5)
	sprite.scale = Vector2(scale_factor, 1.0)
	collision.scale = Vector2(scale_factor, 1.0)