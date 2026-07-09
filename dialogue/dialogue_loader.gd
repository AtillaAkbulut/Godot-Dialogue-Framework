extends Node
class_name DialogueLoader

static func load_dialogue(file_path: String) -> DialogueData:
	var file := FileAccess.open(file_path, FileAccess.READ)
	
	if file == null:
		push_error("Dialogue file not found: " + file_path)
		return null
	
	var text := file.get_as_text()
	var parsed = JSON.parse_string(text)
	
	if typeof(parsed) != TYPE_DICTIONARY:
		push_error("Invalid dialogue JSON: " + file_path)
		return null
	
	return _build_dialogue_data(parsed)

static func _build_dialogue_data(data: Dictionary) -> DialogueData:
	var speaker := load_speaker(data)
	var start_node_id: String = data.get("start", "")
	var nodes := _load_nodes(data.get("nodes", {}))
	
	return DialogueData.new(speaker, start_node_id, nodes)

static func load_speaker(data: Dictionary) -> DialogueSpeaker:
	var speaker_data: Dictionary = data.get("speaker", {})
	
	return DialogueSpeaker.new(
		speaker_data.get("name", ""),
		speaker_data.get("portrait", "")
	)

static func _load_nodes(raw_nodes: Dictionary) -> Dictionary:
	var nodes: Dictionary = {}
	
	for node_id in raw_nodes.keys():
		var raw_node: Dictionary = raw_nodes[node_id]
		var choices := load_choices(raw_node.get("choices", []))
		
		var node := DialogueNode.new(
			node_id,
			raw_node.get("text", ""),
			raw_node.get("next", ""),
			choices,
			raw_node.get("end", false),
			raw_node.get("event", "")
		)
		
		nodes[node_id] = node
	
	return nodes

static func load_choices(raw_choices: Array) -> Array:
	var choices: Array = []
	
	for raw_choice in raw_choices:
		if typeof(raw_choice) != TYPE_DICTIONARY:
			continue
		
		var choice := DialogueChoice.new(
			raw_choice.get("text", ""),
			raw_choice.get("next", ""),
			raw_choice.get("event", "")
		)
		
		choices.append(choice)
	
	return choices
