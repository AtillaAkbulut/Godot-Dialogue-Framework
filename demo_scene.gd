extends Node2D

@onready var quest_example: QuestExample = $QuestExample


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
	GameState.set_variable("player_name", "Atilla")
	GameState.set_variable("gold", 120)

	GameState.set_flag("talked_to_old_man", false)
	GameState.set_flag("has_old_key", false)
	GameState.set_flag("key_already_given", false)

	quest_example.reset_quest("old_key_quest")
	_sync_quest_flags()


func _connect_dialogue_events() -> void:
	if not DialogueManager.dialogue_event_triggered.is_connected(
		_on_dialogue_event_triggered
	):
		DialogueManager.dialogue_event_triggered.connect(
			_on_dialogue_event_triggered
		)


func _sync_quest_flags() -> void:
	GameState.set_flag(
		"old_key_quest_active",
		quest_example.is_quest_active("old_key_quest")
	)

	GameState.set_flag(
		"old_key_quest_completed",
		quest_example.is_quest_completed("old_key_quest")
	)

	print(
		"Quest flags synced | active: ",
		GameState.has_flag("old_key_quest_active"),
		" | completed: ",
		GameState.has_flag("old_key_quest_completed")
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


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("give_test_key"):
		if quest_example.is_quest_active("old_key_quest"):
			GameState.set_flag("has_old_key", true)
			print("Test item received: old key")
		else:
			print("The old key quest is not active.")
