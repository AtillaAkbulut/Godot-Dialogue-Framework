extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DialogueVariableResolver.set_provider(
		Callable(GameState, "get_variable")
	)
	
	DialogueConditionResolver.set_provider(
		Callable(GameState, "has_flag")
	)
	
	GameState.set_variable("player_name", "Atilla")
	GameState.set_variable("gold", 120)
	
	GameState.set_flag("quest_1_active", false)
	GameState.set_flag("has_old_key", false)
	GameState.set_flag("key_already_given", true)
	
	DialogueManager.dialogue_event_triggered.connect(
		_on_dialogue_event_triggered
	)
	
	

func _on_dialogue_event_triggered(event_id: String) -> void:
	print("Dialogue Event Triggered: ", event_id)

	match event_id:
		"old_key_given":
			GameState.set_flag("has_old_key", false)
			GameState.set_flag("key_already_given", true)

		"quest_1_completed":
			GameState.set_flag("quest_1_active", false)
