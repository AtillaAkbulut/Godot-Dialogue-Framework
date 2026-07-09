extends Node

signal dialogue_started
signal line_changed(line_data: Dictionary)
signal choices_requested(choices: Array)
signal choice_selection_changed(index: int)
signal dialogue_finished

signal choices_ready(choices: Array)

enum DialogueState {
	INACTIVE,
	TYPING,
	WAITING_INPUT,
	CHOOSING
}

var state: DialogueState = DialogueState.INACTIVE

var dialogue_data: Dictionary = {}
var current_node_id: String = ""
var is_active: bool = false

var lock_movement: bool = true

var current_choices: Array = []
var selected_choice_index: int = 0

func start_dialogue(data: Dictionary, start_node: String = "", should_lock_movement: bool = true) -> void:
	if data.is_empty():
		push_error("Dialogue data is empty.")
		return
	
	dialogue_data = data
	current_node_id = start_node if start_node != "" else dialogue_data.get("start", "")
	is_active = true
	lock_movement = should_lock_movement
	state = DialogueState.WAITING_INPUT
	
	dialogue_started.emit()
	_show_current_node()

func advance() -> void:
	if not is_active:
		return
	
	match state:
		DialogueState.TYPING:
			# Typewriter skip UI tarafında yapılıyor.
			# Manager burada bir şey yapmaz.
			return
		
		DialogueState.CHOOSING:
			confirm_selection()
			return
		
		DialogueState.WAITING_INPUT:
			_go_to_next_node()
			return
		
		DialogueState.INACTIVE:
			return

func move_selection_up() -> void:
	if current_choices.is_empty():
		return
	
	selected_choice_index -= 1
	
	if selected_choice_index < 0:
		selected_choice_index = current_choices.size() - 1
	
	choice_selection_changed.emit(selected_choice_index)

func move_selection_down() -> void:
	if current_choices.is_empty():
		return
	
	selected_choice_index += 1
	
	if selected_choice_index >= current_choices.size():
		selected_choice_index = 0
	
	choice_selection_changed.emit(selected_choice_index)

func confirm_selection() -> void:
	if current_choices.is_empty():
		return
	
	var choice: Dictionary = current_choices[selected_choice_index]
	
	if choice.has("next"):
		current_node_id = choice["next"]
		_show_current_node()
	else:
		end_dialogue()

func end_dialogue() -> void:
	is_active = false
	dialogue_data = {}
	current_node_id = ""
	current_choices = []
	selected_choice_index = 0
	lock_movement = true
	state = DialogueState.INACTIVE
	dialogue_finished.emit()

func _show_current_node() -> void:
	current_choices = []
	selected_choice_index = 0
	state = DialogueState.WAITING_INPUT
	
	var node := _get_current_node()
	var line_data := _build_line_data(node)
	line_changed.emit(line_data)
	
	if node.has("choices"):
		current_choices = node["choices"]

func request_choices_after_text_finished() -> void:
	if current_choices.is_empty():
		state = DialogueState.WAITING_INPUT
		return
	
	state = DialogueState.CHOOSING
	choices_requested.emit(current_choices)
	choice_selection_changed.emit(selected_choice_index)

func _get_current_node() -> Dictionary:
	if not dialogue_data.has("nodes"):
		return {}
	
	var nodes: Dictionary = dialogue_data["nodes"]
	
	if not nodes.has(current_node_id):
		push_error("Dialogue node not found: " + current_node_id)
		return {}
	
	return nodes[current_node_id]


func set_typing_state() -> void:
	state = DialogueState.TYPING

func set_waiting_input_state() -> void:
	if current_choices.is_empty():
		state = DialogueState.WAITING_INPUT
	else:
		state = DialogueState.CHOOSING

func is_typing() -> bool:
	return state == DialogueState.TYPING

func is_waiting_input() -> bool:
	return state == DialogueState.WAITING_INPUT

func is_choosing() -> bool:
	return state == DialogueState.CHOOSING

func _go_to_next_node() -> void:
	var node := _get_current_node()
	
	if node.has("end") and node["end"] == true:
		end_dialogue()
		return
	
	if node.has("next"):
		current_node_id = node["next"]
		_show_current_node()
	else:
		end_dialogue()

func _build_line_data(node: Dictionary) -> Dictionary:
	var speaker_data: Dictionary = dialogue_data.get("speaker", {})
	
	var line_data := node.duplicate()
	line_data["speaker"] = speaker_data.get("name", "")
	line_data["portrait"] = speaker_data.get("portrait", "")
	
	return line_data
