extends Node

const SAVE_PATH = "res://savegame.bin"

func saveGame():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		var data: Dictionary = {
			"playerHp": Game.playerHp,
			"Gold": Game.Gold
		}
		var jstr = JSON.stringify(data)
		file.store_line(jstr)
		print("Game saved:", jstr)
	else:
		print("Failed to open file for saving.")

func loadGame():
	if not FileAccess.file_exists(SAVE_PATH):
		print("No save file found at", SAVE_PATH)
		return

	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		var jstr = file.get_line()
		print("Loaded JSON string:", jstr)
		var result = JSON.parse_string(jstr)

		if typeof(result) == TYPE_DICTIONARY:
			Game.playerHp = result.get("playerHp", 10)
			Game.Gold = result.get("Gold", 0)
			print("Game loaded: HP =", Game.playerHp, ", Gold =", Game.Gold)
		else:
			print("Failed to parse JSON:", result)
	else:
		print("Failed to open file for loading.")
