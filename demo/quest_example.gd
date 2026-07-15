extends Node
class_name QuestExample

enum QuestState {
	NOT_STARTED,
	ACTIVE,
	COMPLETED
}

var quest_states: Dictionary = {}


func start_quest(quest_id: String) -> void:
	if quest_id.is_empty():
		push_warning("Quest ID cannot be empty.")
		return
	
	var current_state := get_quest_state(quest_id)
	
	if current_state == QuestState.COMPLETED:
		return
	
	quest_states[quest_id] = QuestState.ACTIVE
	
	print("Quest started: ", quest_id)


func complete_quest(quest_id: String) -> void:
	if quest_id.is_empty():
		push_warning("Quest ID cannot be empty.")
		return
	
	quest_states[quest_id] = QuestState.COMPLETED
	
	print("Quest completed: ", quest_id)


func reset_quest(quest_id: String) -> void:
	quest_states[quest_id] = QuestState.NOT_STARTED


func get_quest_state(quest_id: String) -> QuestState:
	return quest_states.get(
		quest_id,
		QuestState.NOT_STARTED
	)


func is_quest_active(quest_id: String) -> bool:
	return get_quest_state(quest_id) == QuestState.ACTIVE


func is_quest_completed(quest_id: String) -> bool:
	return get_quest_state(quest_id) == QuestState.COMPLETED


func get_save_data() -> Dictionary:
	return {
		"quest_states": quest_states.duplicate(true)
	}


func load_save_data(data: Dictionary) -> void:
	var loaded_quest_states = data.get("quest_states", {})
	
	if typeof(loaded_quest_states) != TYPE_DICTIONARY:
		push_warning("Quest save data contains invalid quest states.")
		quest_states = {}
		return
	
	quest_states = loaded_quest_states.duplicate(true)


func reset_all_quests() -> void:
	quest_states.clear()
