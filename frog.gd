extends CharacterBody2D

var SPEED = 50
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player
var chase = false

func _ready():
	$AnimatedSprite2D.play("Idle")

func _physics_process(delta):
	# Apply gravity
	velocity.y += gravity * delta

	if chase==true:
		if $AnimatedSprite2D.animation != "Death":
			$AnimatedSprite2D.play("Jump")
		
		player = get_node("../../Player/Player")  # Adjust path as per your scene
		var direction = (player.position - position).normalized()

		# Flip sprite based on direction
		$AnimatedSprite2D.flip_h = direction.x > 0

		# Move toward player
		velocity.x = direction.x * SPEED
	else:
		if $AnimatedSprite2D.animation != "Death":
			$AnimatedSprite2D.play("Idle")
		velocity.x = 0

	move_and_slide()

func _on_player_detection_body_entered(body):
	if body.name == "Player":
		chase = true

func _on_player_detection_body_exited(body):
	if body.name == "Player":
		chase = false


func _on_player_death_body_entered(body):
	if body.name == "Player":
		$AnimatedSprite2D.play("Death")
		await $AnimatedSprite2D.animation_finished
		self.queue_free()


func _on_player_collusion_body_entered(body: Node2D) -> void:
		if body.name == "Player":
			Game.playerHp-=1
			Game.Gold+=5

func death():
	Game.Gold+=5
	Utils.saveGame()
	chase=false
	$AnimatedSprite2D.play("Death")
	await $AnimatedSprite2D.animation_finished
	self.queue_free()
