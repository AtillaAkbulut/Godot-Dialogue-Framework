extends RefCounted
class_name DialogueVariableResolver

static var _variable_provider: Callable


static func set_provider(provider: Callable) -> void:
	if not provider.is_valid():
		push_error("DialogueVariableResolver received an invalid provider.")
		return
	
	_variable_provider = provider


static func clear_provider() -> void:
	_variable_provider = Callable()


static func resolve_text(text: String) -> String:
	if text.is_empty():
		return text
	
	var regex := RegEx.new()
	var compile_error := regex.compile(r"\{([a-zA-Z0-9_]+)\}")
	
	if compile_error != OK:
		push_error("Could not compile dialogue variable pattern.")
		return text
	
	var resolved_text := text
	var matches := regex.search_all(text)
	
	for regex_match in matches:
		var placeholder: String = regex_match.get_string(0)
		var variable_name: String = regex_match.get_string(1)
		var value = _get_variable(variable_name)
		
		resolved_text = resolved_text.replace(
			placeholder,
			str(value)
		)
	
	return resolved_text


static func _get_variable(variable_name: String):
	if not _variable_provider.is_valid():
		push_warning(
			"No variable provider configured. Unresolved variable: "
			+ variable_name
		)
		return "{" + variable_name + "}"
	
	return _variable_provider.call(variable_name, "{" + variable_name + "}")
