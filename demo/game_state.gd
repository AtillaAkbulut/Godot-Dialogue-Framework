extends Node

var flags: Dictionary = {}
var variables: Dictionary = {}





func set_variable(variable_name: String, value) -> void:
	if variable_name.is_empty():
		push_warning("Variable name cannot be empty.")
		return
	
	variables[variable_name] = value


func get_variable(variable_name: String, default_value = ""):
	return variables.get(variable_name, default_value)


func remove_variable(variable_name: String) -> void:
	variables.erase(variable_name)


func set_flag(flag_name: String, value: bool = true) -> void:
	if flag_name.is_empty():
		push_warning("Flag name cannot be empty.")
		return
	
	flags[flag_name] = value


func has_flag(flag_name: String) -> bool:
	return flags.get(flag_name, false)


func get_save_data() -> Dictionary:
	return {
		"flags": flags.duplicate(true),
		"variables": variables.duplicate(true)
	}


func load_save_data(data: Dictionary) -> void:
	var loaded_flags = data.get("flags", {})
	var loaded_variables = data.get("variables", {})
	
	if typeof(loaded_flags) == TYPE_DICTIONARY:
		flags = loaded_flags.duplicate(true)
	else:
		push_warning("GameState save data contains invalid flags.")
		flags = {}
	
	if typeof(loaded_variables) == TYPE_DICTIONARY:
		variables = loaded_variables.duplicate(true)
	else:
		push_warning("GameState save data contains invalid variables.")
		variables = {}


func reset_state() -> void:
	flags.clear()
	variables.clear()
