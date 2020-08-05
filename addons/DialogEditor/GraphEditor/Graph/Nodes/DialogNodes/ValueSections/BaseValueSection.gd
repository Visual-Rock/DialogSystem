tool
extends HBoxContainer

export var value_name  : String = ""
export var value_type  : int    = -1

func get_data() -> Dictionary:
	return { "name": value_name, "type": value_type, "value": get_value() }

func get_value():
	pass

func get_value_name() -> String:
	return value_name

func load_from_data(data : Dictionary = {}) -> void:
	pass
