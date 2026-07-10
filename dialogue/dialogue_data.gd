extends RefCounted
class_name DialogueData

var speaker: DialogueSpeaker = null
var start_node_id: String = ""
var nodes: Dictionary = {}

var start_rules: Array = []

func _init(
	_speaker: DialogueSpeaker = null,
	_start_node_id: String = "",
	_nodes: Dictionary = {},
	_start_rules: Array = []
) -> void:
	speaker = _speaker
	start_node_id = _start_node_id
	nodes = _nodes
	start_rules = _start_rules

func get_node_by_id(node_id: String) -> DialogueNode:
	if not nodes.has(node_id):
		push_error("Dialogue node not found: " + node_id)
		return null
	
	return nodes[node_id]

func resolve_start_node_id() -> String:
	for rule in start_rules:
		if rule == null:
			continue
		
		if not rule is DialogueStartRule:
			continue
		
		if DialogueConditionResolver.evaluate_all(rule.conditions):
			return rule.start_node_id
	
	return start_node_id
