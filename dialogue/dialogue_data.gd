extends RefCounted
class_name DialogueData

var speaker: DialogueSpeaker = null
var start_node_id: String = ""
var nodes: Dictionary = {}

func _init(
	_speaker: DialogueSpeaker = null,
	_start_node_id: String = "",
	_nodes: Dictionary = {}
) -> void:
	speaker = _speaker
	start_node_id = _start_node_id
	nodes = _nodes

func get_node_by_id(node_id: String) -> DialogueNode:
	if not nodes.has(node_id):
		push_error("Dialogue node not found: " + node_id)
		return null
	
	return nodes[node_id]
