@tool
extends "res://addons/dialogsystem/graph_editor/graph/nodes/value_sections/base_value_section.gd"

@onready var Name     : Label    = self.get_node("VBoxContainer/Label")
@onready var EditText : TextEdit = self.get_node("VBoxContainer/TextEdit")

func get_value():
	return EditText.text

func load_from_data(data : Dictionary = {}) -> void:
	Name.text = str(data["name"], ": ")
	value_name = data["name"]
	value_type = ValueTypes.MultiLineString
	if data.has("value"):
		EditText.text = data["value"]
	elif data.has("default"):
		EditText.text = data["default"]
	if data.has("default"):
		value_default = [data["default"]]
