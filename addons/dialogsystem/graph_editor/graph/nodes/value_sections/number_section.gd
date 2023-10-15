@tool
extends "res://addons/dialogsystem/graph_editor/graph/nodes/value_sections/base_value_section.gd"

@onready var Name   : Label   = self.get_node("Name")
@onready var Number : SpinBox = self.get_node("SpinBox")

var values 

func get_value():
	return Number.value

func load_from_data(data : Dictionary = {}) -> void:
	Name.text = str(data["name"], ": ")
	value_name = data["name"]
	value_type = ValueTypes.Number
	
	if data.has("min"):
		Number.min_value = data["min"]
	if data.has("max"):
		Number.max_value = data["max"]
	if data.has("step"):
		Number.step = data["step"]
	
	if data.has("default"):
		value_default = [data["default"]]
		Number.set_value(value_default[0])
		Number.apply()
	
	if data.has("value"):
		Number.set_value(data["value"])
		Number.apply()

func get_save_data() -> Dictionary:
	var ret : Dictionary = get_data()
	ret["default"]  = value_default[0]
	ret["min"] = Number.min_value
	ret["max"] = Number.max_value
	ret["step"] = Number.step
	return ret
