extends Node

signal dialogue_started
signal line_changed(line_data: Dictionary)
signal choices_requested(choices: Array)
signal choice_selection_changed(index: int)
signal dialogue_finished

signal dialogue_event_triggered(event_id: String)

signal choices_ready(choices: Array)

enum DialogueState {
	INACTIVE,
	TYPING,
	WAITING_INPUT,
	CHOOSING
}

var current_speaker: DialogueSpeaker = null

var state: DialogueState = DialogueState.INACTIVE

var dialogue_data: DialogueData = null
var current_node_id: String = ""
var current_node: DialogueNode = null
var is_active: bool = false

var lock_movement: bool = true

var current_choices: Array = []
var selected_choice_index: int = 0

func start_dialogue(data: DialogueData, start_node: String = "", should_lock_movement: bool = true) -> void:
	if data == null:
		push_error("Dialogue data is null.")
		return
	
	dialogue_data = data
	current_speaker = data.speaker
	current_node_id = start_node if start_node != "" else data.start_node_id
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
	
	var choice: DialogueChoice = current_choices[selected_choice_index]
	
	_trigger_events(choice.events)
	
	if choice.next_node_id != "":
		current_node_id = choice.next_node_id
		_show_current_node()
	else:
		end_dialogue()

func end_dialogue() -> void:
	is_active = false
	dialogue_data = null
	current_node_id = ""
	current_node = null
	current_speaker = null
	current_choices = []
	selected_choice_index = 0
	lock_movement = true
	state = DialogueState.INACTIVE
	dialogue_finished.emit()

func _show_current_node() -> void:
	current_choices = []
	selected_choice_index = 0
	state = DialogueState.WAITING_INPUT
	
	current_node = _get_current_node()
	
	if current_node == null:
		end_dialogue()
		return
	
	line_changed.emit(current_node)
	_trigger_events(current_node.events)
	
	if current_node.choices.size() > 0:
		current_choices = current_node.choices

func request_choices_after_text_finished() -> void:
	if current_choices.is_empty():
		state = DialogueState.WAITING_INPUT
		return
	
	state = DialogueState.CHOOSING
	choices_requested.emit(current_choices)
	choice_selection_changed.emit(selected_choice_index)

func _get_current_node() -> DialogueNode:
	if dialogue_data == null:
		return null
	
	return dialogue_data.get_node_by_id(current_node_id)


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
	if current_node == null:
		end_dialogue()
		return
	
	if current_node.end:
		end_dialogue()
		return
	
	if current_node.next_node_id != "":
		current_node_id = current_node.next_node_id
		_show_current_node()
	else:
		end_dialogue()

func _trigger_events(events: Array) -> void:
	
	
	for event_id in events:
		if typeof(event_id) != TYPE_STRING:
			continue
		
		if event_id == "":
			continue
		
		
		dialogue_event_triggered.emit(event_id)
