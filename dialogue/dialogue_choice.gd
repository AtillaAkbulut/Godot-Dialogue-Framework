extends RefCounted
class_name DialogueChoice

var text: String = ""
var next_node_id: String = ""
var event_id: String = ""

func _init(_text: String = "", _next_node_id: String = "", _event_id: String = "") -> void:
	text = _text
	next_node_id = _next_node_id
	event_id = _event_id
