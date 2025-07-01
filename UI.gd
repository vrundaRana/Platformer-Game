extends CanvasLayer

@onready var score_label = $ScoreLabel
@onready var distance_label = $DistanceLabel
@onready var hp_label = $HPLabel
@onready var game_over_panel = $GameOverPanel
@onready var final_score_label = $GameOverPanel/VBoxContainer/FinalScoreLabel
@onready var final_distance_label = $GameOverPanel/VBoxContainer/FinalDistanceLabel
@onready var high_score_label = $GameOverPanel/VBoxContainer/HighScoreLabel
@onready var restart_button = $GameOverPanel/VBoxContainer/RestartButton
@onready var menu_button = $GameOverPanel/VBoxContainer/MenuButton
@onready var pause_button = $PauseButton
@onready var pause_panel = $PausePanel
@onready var resume_button = $PausePanel/VBoxContainer/ResumeButton
@onready var pause_menu_button = $PausePanel/VBoxContainer/MenuButton
@onready var speed_boost_label = $SpeedBoostLabel

func _ready():
	game_over_panel.visible = false
	pause_panel.visible = false
	speed_boost_label.visible = false
	update_hp(Game.playerHp)
	
	restart_button.pressed.connect(_on_restart_pressed)
	menu_button.pressed.connect(_on_menu_pressed)
	pause_button.pressed.connect(_on_pause_pressed)
	resume_button.pressed.connect(_on_resume_pressed)
	pause_menu_button.pressed.connect(_on_menu_pressed)

func update_score(score):
	score_label.text = "Score: " + str(score)

func update_distance(distance):
	distance_label.text = "Distance: " + str(distance) + "m"

func update_hp(hp):
	hp_label.text = "HP: " + str(hp)

func show_game_over(final_score, final_distance):
	Game.save_high_score(final_score, final_distance)
	game_over_panel.visible = true
	final_score_label.text = "Final Score: " + str(final_score)
	final_distance_label.text = "Distance: " + str(final_distance) + "m"
	high_score_label.text = "High Score: " + str(Game.high_score) + " | Best Distance: " + str(Game.high_distance) + "m"

func show_speed_boost():
	speed_boost_label.visible = true
	speed_boost_label.text = "SPEED BOOST!"
	var tween = create_tween()
	tween.tween_property(speed_boost_label, "modulate:a", 0.0, 2.0)
	tween.tween_callback(func(): speed_boost_label.visible = false)

func _on_restart_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://MainMenu.tscn")

func _on_pause_pressed():
	get_tree().paused = true
	pause_panel.visible = true

func _on_resume_pressed():
	get_tree().paused = false
	pause_panel.visible = false

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if pause_panel.visible:
			_on_resume_pressed()
		elif not game_over_panel.visible:
			_on_pause_pressed()