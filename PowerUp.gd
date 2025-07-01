extends Area2D

enum PowerUpType { SPEED_BOOST, SHIELD, DOUBLE_JUMP, MAGNET }

@export var power_up_type: PowerUpType = PowerUpType.SPEED_BOOST
@onready var sprite = $Sprite2D
@onready var particles = $CPUParticles2D

func _ready():
	body_entered.connect(_on_body_entered)
	setup_visual()

func setup_visual():
	match power_up_type:
		PowerUpType.SPEED_BOOST:
			sprite.modulate = Color.YELLOW
		PowerUpType.SHIELD:
			sprite.modulate = Color.BLUE
		PowerUpType.DOUBLE_JUMP:
			sprite.modulate = Color.GREEN
		PowerUpType.MAGNET:
			sprite.modulate = Color.MAGENTA

func _on_body_entered(body):
	if body.has_method("apply_power_up"):
		body.apply_power_up(power_up_type)
		particles.emitting = true
		sprite.visible = false
		await get_tree().create_timer(1.0).timeout
		queue_free()