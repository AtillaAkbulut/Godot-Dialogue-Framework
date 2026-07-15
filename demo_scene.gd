extends Node2D

@onready var quest_example: QuestExample = $QuestExample
@onready var save_example: SaveExample = $SaveExample


func _ready() -> void:
	_setup_dialogue_providers()
	_connect_dialogue_events()
	
	save_example.configure(quest_example)
	
	if save_example.has_save():
		var loaded := save_example.load_game()
		
		if not loaded:
			_setup_new_game_state()
	else:
		_setup_new_game_state()
	
	_print_current_state()


func _setup_dialogue_providers() -> void:
	DialogueVariableResolver.set_provider(
		Callable(GameState, "get_variable")
	)
	
	DialogueConditionResolver.set_provider(
		Callable(GameState, "has_flag")
	)


func _connect_dialogue_events() -> void:
	if not DialogueManager.dialogue_event_triggered.is_connected(
		_on_dialogue_event_triggered
	):
		DialogueManager.dialogue_event_triggered.connect(
			_on_dialogue_event_triggered
		)


func _setup_new_game_state() -> void:
	GameState.reset_state()
	quest_example.reset_all_quests()
	
	GameState.set_variable("player_name", "Atilla")
	GameState.set_variable("gold", 120)
	
	GameState.set_flag("talked_to_old_man", false)
	GameState.set_flag("has_old_key", false)
	GameState.set_flag("key_already_given", false)
	
	quest_example.reset_quest("old_key_quest")
	_sync_quest_flags()
	
	print("New demo state created.")


func _sync_quest_flags() -> void:
	GameState.set_flag(
		"old_key_quest_active",
		quest_example.is_quest_active("old_key_quest")
	)
	
	GameState.set_flag(
		"old_key_quest_completed",
		quest_example.is_quest_completed("old_key_quest")
	)


func _on_dialogue_event_triggered(event_id: String) -> void:
	print("Dialogue Event Triggered: ", event_id)
	
	match event_id:
		"old_man_met_player":
			GameState.set_flag("talked_to_old_man", true)
		
		"old_key_quest_started":
			quest_example.start_quest("old_key_quest")
			_sync_quest_flags()
		
		"old_key_given":
			GameState.set_flag("has_old_key", false)
			GameState.set_flag("key_already_given", true)
		
		"old_key_quest_completed":
			quest_example.complete_quest("old_key_quest")
			_sync_quest_flags()
		
		_:
			print("Unhandled dialogue event: ", event_id)
	
	_print_current_state()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("give_test_key"):
		GameState.set_flag("has_old_key", true)
		print("Test item received: old key")
		_print_current_state()
	
	elif event.is_action_pressed("save_demo"):
		save_example.save_game()
	
	elif event.is_action_pressed("load_demo"):
		if save_example.load_game():
			_print_current_state()
	
	elif event.is_action_pressed("delete_demo_save"):
		if save_example.delete_save():
			_setup_new_game_state()
			_print_current_state()


func _print_current_state() -> void:
	print("--- Current Demo State ---")
	print(
		"talked_to_old_man: ",
		GameState.has_flag("talked_to_old_man")
	)
	print(
		"old_key_quest_active: ",
		GameState.has_flag("old_key_quest_active")
	)
	print(
		"old_key_quest_completed: ",
		GameState.has_flag("old_key_quest_completed")
	)
	print(
		"has_old_key: ",
		GameState.has_flag("has_old_key")
	)
	print(
		"key_already_given: ",
		GameState.has_flag("key_already_given")
	)
	print(
		"player_name: ",
		GameState.get_variable("player_name", "Unknown")
	)
	print("--------------------------")
