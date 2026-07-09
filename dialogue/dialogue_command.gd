extends RefCounted
class_name DialogueCommand

var type: String = ""
var value = null
var duration: float = 0.0

func _init(_type: String = "", _value = null, _duration: float = 0.0) -> void:
	type = _type
	value = _value
	duration = _duration
