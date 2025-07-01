extends Node2D

@export var platform_scene: PackedScene
@export var obstacle_scene: PackedScene
@export var collectible_scene: PackedScene

var spawn_distance = 800.0
var last_spawn_x = 0.0
var platforms = []
var camera_ref

func _ready():
	camera_ref = get_parent().get_node("Camera2D")
	# Create initial platforms (skip x=0, that's the fixed spawn platform)
	for i in range(1, 8):
		spawn_platform(i * 120.0)

func _process(delta):
	var camera_x = camera_ref.global_position.x
	
	# Spawn new platforms ahead of camera
	while last_spawn_x < camera_x + spawn_distance:
		spawn_platform(last_spawn_x + randf_range(80, 150))
	
	# Remove old platforms behind camera
	cleanup_old_platforms(camera_x - 500)

func spawn_platform(x_pos):
	var platform = preload("res://Platform.tscn").instantiate()
	var y_pos = 350.0 if x_pos == 0.0 else randf_range(250, 400)
	platform.global_position = Vector2(x_pos, y_pos)
	add_child(platform)
	platforms.append(platform)
	last_spawn_x = x_pos
	
	# Randomly spawn collectibles, obstacles, or power-ups
	var rand = randf()
	if rand < 0.3:  # 30% chance for collectible
		spawn_collectible(Vector2(x_pos, platform.global_position.y - 50))
	elif rand < 0.45:  # 15% chance for obstacle
		spawn_obstacle(Vector2(x_pos + 100, platform.global_position.y - 30))
	elif rand < 0.55:  # 10% chance for power-up
		spawn_power_up(Vector2(x_pos + 50, platform.global_position.y - 60))

func spawn_collectible(pos):
	var collectible = preload("res://collectables/Cherry.tscn").instantiate()
	collectible.global_position = pos
	add_child(collectible)

func spawn_obstacle(pos):
	var obstacle = preload("res://Obstacle.tscn").instantiate()
	obstacle.global_position = pos
	add_child(obstacle)

func spawn_power_up(pos):
	var power_up = preload("res://PowerUp.tscn").instantiate()
	power_up.global_position = pos
	power_up.power_up_type = randi() % 4  # Random power-up type
	add_child(power_up)

func cleanup_old_platforms(threshold_x):
	for i in range(platforms.size() - 1, -1, -1):
		if platforms[i].global_position.x < threshold_x:
			platforms[i].queue_free()
			platforms.remove_at(i)