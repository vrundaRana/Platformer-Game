extends Camera2D

@export var follow_speed = 5.0
@export var offset_x = 100.0

var target: Node2D

func _ready():
	target = get_parent().get_node("Player")

func _process(delta):
	if target:
		var target_pos = Vector2(target.global_position.x + offset_x, target.global_position.y - 50)
		global_position = global_position.lerp(target_pos, follow_speed * delta)