extends Node

var playerHp = 3
var Gold = 0
var high_score = 0
var high_distance = 0

func reset_game():
	playerHp = 3
	Gold = 0

func save_high_score(score, distance):
	if score > high_score:
		high_score = score
	if distance > high_distance:
		high_distance = distance
	Utils.saveGame()
