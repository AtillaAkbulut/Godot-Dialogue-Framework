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
	var start_rules := _load_start_rules(data)
	
	return DialogueData.new(
		speaker,
		start_node_id,
		nodes,
		start_rules
	)

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
			_load_events(raw_node),
			_load_commands(raw_node)
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
			_load_events(raw_choice),
			_load_conditions(raw_choice)
		)
		
		choices.append(choice)
	
	return choices

static func _load_events(data: Dictionary) -> Array:
	if data.has("events") and typeof(data["events"]) == TYPE_ARRAY:
		
		return data["events"]
	
	if data.has("event") and typeof(data["event"]) == TYPE_STRING:
		
		return [data["event"]]
	
	return []

static func _load_commands(data: Dictionary) -> Array:
	var commands: Array = []
	
	if not data.has("commands"):
		return commands
	
	var raw_commands = data["commands"]
	
	if typeof(raw_commands) != TYPE_ARRAY:
		return commands
	
	for raw_command in raw_commands:
		if typeof(raw_command) != TYPE_DICTIONARY:
			continue
		
		var command := DialogueCommand.new(
			raw_command.get("type", ""),
			raw_command.get("value", null),
			raw_command.get("duration", 0.0)
		)
		
		commands.append(command)
	
	return commands

static func _load_conditions(data: Dictionary) -> Array:
	if data.has("conditions") and typeof(data["conditions"]) == TYPE_ARRAY:
		return data["conditions"].duplicate()
	
	if data.has("condition") and typeof(data["condition"]) == TYPE_STRING:
		return [data["condition"]]
	
	return []

static func _load_start_rules(data: Dictionary) -> Array:
	var rules: Array = []
	var raw_rules = data.get("start_rules", [])
	
	if typeof(raw_rules) != TYPE_ARRAY:
		return rules
	
	for raw_rule in raw_rules:
		if typeof(raw_rule) != TYPE_DICTIONARY:
			continue
		
		var start_node_id: String = raw_rule.get("start", "")
		
		if start_node_id.is_empty():
			push_warning("Dialogue start rule is missing a start node.")
			continue
		
		var rule := DialogueStartRule.new(
			start_node_id,
			_load_conditions(raw_rule)
		)
		
		rules.append(rule)
	
	return rules
