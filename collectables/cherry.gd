extends Area2D

func _ready():
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
	add_to_group("collectibles")

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("collect_item"):
		body.collect_item(10)
		Game.Gold += 1
		var tween = get_tree().create_tween()
		var tween1 = get_tree().create_tween()
		tween.tween_property(self, "position", position - Vector2(0, 25), 0.3)
		tween1.tween_property(self, "modulate:a", 0, 0.3)
		tween.tween_callback(queue_free)
