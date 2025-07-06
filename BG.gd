extends ParallaxBackground
var scrolling_speed=100
func _process(delta):
	scroll_offset.x -= scrolling_speed * delta
	# Fix seamless scrolling
	for layer in get_children():
		if layer is ParallaxLayer:
			layer.motion_mirroring.x = layer.get_child(0).texture.get_width() * layer.get_child(0).scale.x
