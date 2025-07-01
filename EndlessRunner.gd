extends Node2D

@onready var player = $Player
@onready var camera = $Camera2D
@onready var platform_spawner = $PlatformSpawner
@onready var ui = $UI

var game_speed = 200.0
var distance = 0.0
var score = 0
var is_game_over = false
var difficulty_timer = 0.0

func _ready():
	Game.reset_game()
	ui.update_score(score)
	ui.update_distance(int(distance))

func _process(delta):
	if is_game_over:
		return
		
	# Increase distance and difficulty
	distance += game_speed * delta / 100.0
	difficulty_timer += delta
	
	# Increase speed every 10 seconds
	if difficulty_timer >= 10.0:
		game_speed += 20.0
		difficulty_timer = 0.0
		ui.show_speed_boost()
	
	ui.update_distance(int(distance))
	
	# Check if player fell
	if player.global_position.y > 1000:
		game_over()

func add_score(points):
	score += points
	ui.update_score(score)

func game_over():
	if is_game_over:
		return
	is_game_over = true
	Game.playerHp = 0
	ui.show_game_over(score, int(distance))
	get_tree().paused = true

func restart_game():
	get_tree().paused = false
	get_tree().reload_current_scene()