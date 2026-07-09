extends RefCounted
class_name DialogueNode

var id: String = ""
var text: String = ""
var next_node_id: String = ""
var choices: Array = []
var end: bool = false
var events: Array = []
var commands: Array = []

func _init(
	_id: String = "",
	_text: String = "",
	_next_node_id: String = "",
	_choices: Array = [],
	_end: bool = false,
	_events: Array = [],
	_commands: Array = []
) -> void:
	id = _id
	text = _text
	next_node_id = _next_node_id
	choices = _choices
	end = _end
	events = _events
	commands = _commands
