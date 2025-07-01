extends CharacterBody2D

const JUMP_VELOCITY = -500.0
const GRAVITY = 1200.0
const AUTO_RUN_SPEED = 200.0

@onready var anim = get_node("AnimationPlayer")
@onready var sprite = get_node("AnimatedSprite2D")
@onready var jump_sound = $JumpSound
@onready var collect_sound = $CollectSound

var is_jumping = false
var can_double_jump = true
var game_speed_multiplier = 1.0
var has_shield = false
var shield_timer = 0.0
var speed_boost_timer = 0.0
var magnet_timer = 0.0

func _ready():
	sprite.flip_h = false

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		can_double_jump = true
		is_jumping = false

	# Handle horizontal movement
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		sprite.flip_h = direction < 0
		var speed = AUTO_RUN_SPEED
		if speed_boost_timer > 0:
			speed *= 1.5
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, AUTO_RUN_SPEED)

	if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_up"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
			is_jumping = true
			anim.play("Jump")
			jump_sound.play()
		elif can_double_jump:
			velocity.y = JUMP_VELOCITY * 0.8
			can_double_jump = false
			anim.play("Jump")
			jump_sound.play()

	# Animation logic
	if is_on_floor():
		if direction != 0 and not is_jumping:
			anim.play("Run")
		elif direction == 0 and not is_jumping:
			anim.play("Idle")
	else:
		if velocity.y > 0:
			anim.play("Fall")

	move_and_slide()

	if Game.playerHp <= 0:
		get_parent().game_over()

func take_damage(amount = 1):
	if has_shield:
		return  # Shield blocks damage
	Game.playerHp -= amount
	get_parent().get_node("UI").update_hp(Game.playerHp)
	if Game.playerHp <= 0:
		get_parent().game_over()

func collect_item(points = 10):
	get_parent().add_score(points)
	collect_sound.play()

func apply_power_up(type):
	match type:
		0:  # SPEED_BOOST
			speed_boost_timer = 5.0
			get_parent().add_score(20)
		1:  # SHIELD
			has_shield = true
			shield_timer = 10.0
			sprite.modulate = Color.CYAN
		2:  # DOUBLE_JUMP
			can_double_jump = true
		3:  # MAGNET
			magnet_timer = 8.0

func _process(_delta):
	# Handle power-up timers
	if shield_timer > 0:
		shield_timer -= _delta
		if shield_timer <= 0:
			has_shield = false
			sprite.modulate = Color.WHITE
	
	if speed_boost_timer > 0:
		speed_boost_timer -= _delta
	
	if magnet_timer > 0:
		magnet_timer -= _delta
		# Attract nearby collectibles
		var collectibles = get_tree().get_nodes_in_group("collectibles")
		for collectible in collectibles:
			if global_position.distance_to(collectible.global_position) < 150:
				collectible.global_position = collectible.global_position.move_toward(global_position, 300 * _delta)
