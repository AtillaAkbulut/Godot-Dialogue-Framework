extends Node
class_name DialogueLoader

static func load_dialogue(file_path: String) -> Dictionary:
	var file := FileAccess.open(file_path, FileAccess.READ)
	
	if file == null:
		push_error("Dialogue file not found: " + file_path)
		return {}
	
	var text := file.get_as_text()
	var parsed = JSON.parse_string(text)
	
	if typeof(parsed) != TYPE_DICTIONARY:
		push_error("Invalid dialogue JSON: " + file_path)
		return {}
	
	return parsed

static func load_speaker(data: Dictionary) -> DialogueSpeaker:
	var speaker_data: Dictionary = data.get("speaker", {})
	
	return DialogueSpeaker.new(
		speaker_data.get("name", ""),
		speaker_data.get("portrait", "")
	)
