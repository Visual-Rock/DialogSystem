tool
extends HBoxContainer

export var value_name    : String = ""
export var value_type    : int    = -1
export var value_default : Array  = []

func get_data() -> Dictionary:
	return { "name": value_name, "type": value_type, "value": get_value() }

func get_value_data() -> Dictionary:
	return {}

func get_save_data() -> Dictionary:
	var rtrn : Dictionary = get_data()
	rtrn["default"]  = value_default[0]
	return rtrn

func get_value():
	pass

func get_value_name() -> String:
	return value_name

func is_default_value() -> bool:
	return value_default[0] == get_value()

func get_default_value() -> Array:
	return value_default

func load_from_data(data : Dictionary = {}) -> void:
	pass
