extends RefCounted
class_name DialogueChoice

var text: String = ""
var next_node_id: String = ""
var events: Array = []

func _init(_text: String = "", _next_node_id: String = "", _events: Array = []) -> void:
	text = _text
	next_node_id = _next_node_id
	events = _events
