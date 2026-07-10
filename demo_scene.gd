extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DialogueVariableResolver.set_provider(
		Callable(GameState, "get_variable")
	)
	
	GameState.set_variable("player_name", "Atilla")
	GameState.set_variable("gold", 120)
	
	DialogueManager.dialogue_event_triggered.connect(
		_on_dialogue_event_triggered
	)


func _on_dialogue_event_triggered(event_id: String) -> void:
	print("Dialogue Event Triggered: ", event_id)
