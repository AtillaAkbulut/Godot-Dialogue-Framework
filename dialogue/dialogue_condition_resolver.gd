extends RefCounted
class_name DialogueConditionResolver

static var _condition_provider: Callable


static func set_provider(provider: Callable) -> void:
	if not provider.is_valid():
		push_error(
			"DialogueConditionResolver received an invalid provider."
		)
		return
	
	_condition_provider = provider


static func clear_provider() -> void:
	_condition_provider = Callable()


static func evaluate(condition_id: String) -> bool:
	if condition_id.is_empty():
		return true
	
	var should_invert := condition_id.begins_with("!")
	var clean_condition_id := condition_id
	
	if should_invert:
		clean_condition_id = condition_id.trim_prefix("!")
	
	var result := _get_condition(clean_condition_id)
	
	return not result if should_invert else result


static func evaluate_all(condition_ids: Array) -> bool:
	for condition_id in condition_ids:
		if typeof(condition_id) != TYPE_STRING:
			push_warning("Dialogue condition must be a String.")
			return false
		
		if not evaluate(condition_id):
			return false
	
	return true


static func _get_condition(condition_id: String) -> bool:
	if not _condition_provider.is_valid():
		push_warning(
			"No condition provider configured. Condition failed: "
			+ condition_id
		)
		return false
	
	return bool(
		_condition_provider.call(condition_id)
	)
