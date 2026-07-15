extends Node
class_name SaveExample

const SAVE_PATH: String = "user://dialogue_framework_demo_save.json"
const SAVE_VERSION: int = 1

var quest_system: QuestExample = null


func configure(_quest_system: QuestExample) -> void:
	quest_system = _quest_system


func save_game() -> bool:
	if quest_system == null:
		push_error("SaveExample has no QuestExample reference.")
		return false
	
	var save_data := {
		"version": SAVE_VERSION,
		"game_state": GameState.get_save_data(),
		"quests": quest_system.get_save_data()
	}
	
	var json_text := JSON.stringify(save_data, "\t")
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	
	if file == null:
		push_error(
			"Could not open save file for writing. Error: "
			+ str(FileAccess.get_open_error())
		)
		return false
	
	file.store_string(json_text)
	file.close()
	
	print("Game saved: ", SAVE_PATH)
	return true


func load_game() -> bool:
	if quest_system == null:
		push_error("SaveExample has no QuestExample reference.")
		return false
	
	if not FileAccess.file_exists(SAVE_PATH):
		print("No save file found.")
		return false
	
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	
	if file == null:
		push_error(
			"Could not open save file for reading. Error: "
			+ str(FileAccess.get_open_error())
		)
		return false
	
	var json_text := file.get_as_text()
	file.close()
	
	var parsed = JSON.parse_string(json_text)
	
	if typeof(parsed) != TYPE_DICTIONARY:
		push_error("Save file contains invalid JSON data.")
		return false
	
	var save_data: Dictionary = parsed
	var version: int = int(save_data.get("version", 0))
	
	if version != SAVE_VERSION:
		push_warning(
			"Save version mismatch. Expected "
			+ str(SAVE_VERSION)
			+ ", received "
			+ str(version)
			+ "."
		)
	
	var game_state_data = save_data.get("game_state", {})
	var quest_data = save_data.get("quests", {})
	
	if typeof(game_state_data) != TYPE_DICTIONARY:
		push_error("Save file contains invalid GameState data.")
		return false
	
	if typeof(quest_data) != TYPE_DICTIONARY:
		push_error("Save file contains invalid quest data.")
		return false
	
	GameState.load_save_data(game_state_data)
	quest_system.load_save_data(quest_data)
	
	print("Game loaded: ", SAVE_PATH)
	return true


func delete_save() -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		print("No save file to delete.")
		return false
	
	var error := DirAccess.remove_absolute(
		ProjectSettings.globalize_path(SAVE_PATH)
	)
	
	if error != OK:
		push_error("Could not delete save file. Error: " + str(error))
		return false
	
	print("Save file deleted.")
	return true


func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)
