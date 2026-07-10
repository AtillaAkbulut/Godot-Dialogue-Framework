extends Node2D


func _ready() -> void:
	_setup_dialogue_providers()
	_setup_demo_state()
	_connect_dialogue_events()


func _setup_dialogue_providers() -> void:
	DialogueVariableResolver.set_provider(
		Callable(GameState, "get_variable")
	)
	
	DialogueConditionResolver.set_provider(
		Callable(GameState, "has_flag")
	)


func _setup_demo_state() -> void:
	# Dialogue variables
	GameState.set_variable("player_name", "Atilla")
	GameState.set_variable("gold", 120)
	
	# NPC memory
	GameState.set_flag("talked_to_old_man", false)
	
	# Quest example
	GameState.set_flag("quest_1_active", false)
	GameState.set_flag("has_old_key", false)
	GameState.set_flag("key_already_given", true)


func _connect_dialogue_events() -> void:
	if not DialogueManager.dialogue_event_triggered.is_connected(
		_on_dialogue_event_triggered
	):
		DialogueManager.dialogue_event_triggered.connect(
			_on_dialogue_event_triggered
		)


func _on_dialogue_event_triggered(event_id: String) -> void:
	print("Dialogue Event Triggered: ", event_id)
	
	match event_id:
		"old_man_met_player":
			GameState.set_flag("talked_to_old_man", true)
		
		"old_key_given":
			GameState.set_flag("has_old_key", false)
			GameState.set_flag("key_already_given", true)
		
		"quest_1_completed":
			GameState.set_flag("quest_1_active", false)
		
		_:
			print("Unhandled dialogue event: ", event_id)
