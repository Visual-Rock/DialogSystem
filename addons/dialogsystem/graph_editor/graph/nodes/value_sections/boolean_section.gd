@tool
extends "res://addons/dialogsystem/graph_editor/graph/nodes/value_sections/base_value_section.gd"

@onready var Name     : Label    = self.get_node("name")
@onready var Checkbox : CheckBox = self.get_node("CheckBox")

func get_value():
	return Checkbox.button_pressed

func load_from_data(data : Dictionary = {}) -> void:
	Name.text = str(data["name"], ": ")
	value_name = data["name"]
	value_type = ValueTypes.Boolean
	if data.has("value"):
		Checkbox.button_pressed = data["value"]
	elif data.has("default"):
		Checkbox.button_pressed = data["default"]
	if data.has("default"):
		value_default = [data["default"]]
