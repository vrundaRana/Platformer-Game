extends Node2D

@onready var play_button = $UI/VBoxContainer/PlayButton

@onready var quit_button = $UI/VBoxContainer/QuitButton
@onready var high_score_label = $UI/HighScoreLabel

func _ready():
	Utils.saveGame()
	play_button.pressed.connect(_on_play_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	high_score_label.text = "High Score: " + str(Game.high_score) + " | Best Distance: " + str(Game.high_distance) + "m"

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://EndlessRunner.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
