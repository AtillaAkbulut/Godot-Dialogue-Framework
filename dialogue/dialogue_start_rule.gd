extends RefCounted
class_name DialogueStartRule

var start_node_id: String = ""
var conditions: Array = []

func _init(
	_start_node_id: String = "",
	_conditions: Array = []
) -> void:
	start_node_id = _start_node_id
	conditions = _conditions
