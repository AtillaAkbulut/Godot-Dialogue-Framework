extends CanvasLayer

@onready var panel: Panel = $Panel
@onready var speaker_label: Label = $Panel/VBoxContainer/SpeakerLabel
@onready var text_label: Label = $Panel/VBoxContainer/TextLabel
@onready var choices_container: VBoxContainer = $Panel/VBoxContainer/ChoicesContainer
@onready var portrait_rect: TextureRect = $Panel/PortraitRect

@export var typewriter_speed: float = 20.0

var full_text: String = ""
var visible_character_count: float = 0.0
var is_typing: bool = false

func _ready() -> void:
	hide()
	portrait_rect.hide()
	
	DialogueManager.dialogue_command_requested.connect(_on_dialogue_command_requested)
	DialogueManager.dialogue_started.connect(_on_dialogue_started)
	DialogueManager.line_changed.connect(_on_line_changed)
	DialogueManager.choices_requested.connect(_on_choices_requested)
	DialogueManager.choice_selection_changed.connect(_on_choice_selection_changed)
	DialogueManager.dialogue_finished.connect(_on_dialogue_finished)

func _process(delta: float) -> void:
	if not is_typing:
		return
	
	visible_character_count += typewriter_speed * delta
	
	if visible_character_count >= full_text.length():
		visible_character_count = full_text.length()
		is_typing = false
		DialogueManager.request_choices_after_text_finished()
	
	text_label.text = full_text.substr(0, int(visible_character_count))

func _unhandled_input(event: InputEvent) -> void:
	if not DialogueManager.is_active:
		return
	
	if event.is_action_pressed("ui_up"):
		DialogueManager.move_selection_up()
		get_viewport().set_input_as_handled()
	
	elif event.is_action_pressed("ui_down"):
		DialogueManager.move_selection_down()
		get_viewport().set_input_as_handled()
	
	elif event.is_action_pressed("ui_accept"):
		if is_typing:
			_skip_typewriter()
		else:
			DialogueManager.advance()
		
		get_viewport().set_input_as_handled()

func _on_dialogue_started() -> void:
	show()

func _on_line_changed(
	dialogue_node: DialogueNode,
	resolved_text: String
) -> void:
	_clear_choices()
	
	DialogueManager.set_typing_state()
	
	if dialogue_node == null:
		return
	
	if DialogueManager.current_speaker != null:
		speaker_label.text = DialogueManager.current_speaker.name
		var portrait_path := DialogueManager.current_speaker.portrait_path
		
		if portrait_path != "":
			var texture := load(portrait_path)
			
			if texture != null:
				portrait_rect.texture = texture
				portrait_rect.show()
			else:
				portrait_rect.texture = null
				portrait_rect.hide()
		else:
			portrait_rect.texture = null
			portrait_rect.hide()
	else:
		speaker_label.text = ""
		portrait_rect.texture = null
		portrait_rect.hide()
	
	full_text = resolved_text
	visible_character_count = 0.0
	is_typing = true
	text_label.text = ""

func _on_choices_requested(choices: Array) -> void:
	_clear_choices()
	
	for choice in choices:
		var label := Label.new()
		label.text = choice.text
		choices_container.add_child(label)

func _on_choice_selection_changed(index: int) -> void:
	var labels := choices_container.get_children()
	
	for i in labels.size():
		var label := labels[i] as Label
		var choice: DialogueChoice = DialogueManager.current_choices[i]
		
		if i == index:
			label.text = "> " + choice.text
		else:
			label.text = "  " + choice.text

func _on_dialogue_finished() -> void:
	hide()
	_clear_choices()
	speaker_label.text = ""
	text_label.text = ""
	portrait_rect.texture = null
	portrait_rect.hide()

func _clear_choices() -> void:
	for child in choices_container.get_children():
		child.queue_free()

func _skip_typewriter() -> void:
	visible_character_count = full_text.length()
	text_label.text = full_text
	is_typing = false
	DialogueManager.request_choices_after_text_finished()

func _on_dialogue_command_requested(command: DialogueCommand) -> void:
	match command.type:
		"set_text_speed":
			if typeof(command.value) == TYPE_FLOAT or typeof(command.value) == TYPE_INT:
				typewriter_speed = float(command.value)
		
		"reset_text_speed":
			typewriter_speed = 45.0
