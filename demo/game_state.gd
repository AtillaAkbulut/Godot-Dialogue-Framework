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
