extends Node

@export_file("*.json") var dialogue_file: String
@export var start_node: String = ""
@export var close_on_area_exit: bool = true
@export var lock_movement: bool = true

func start_dialogue() -> void:
	if dialogue_file.is_empty():
		push_error("Dialogue file is empty on: " + owner.name)
		return
	
	var data := DialogueLoader.load_dialogue(dialogue_file)
	
	if data == null:
		return
	
	DialogueManager.start_dialogue(data, start_node, lock_movement)
