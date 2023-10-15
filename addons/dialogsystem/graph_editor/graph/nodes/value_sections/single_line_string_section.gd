@tool
extends "res://addons/dialogsystem/graph_editor/graph/nodes/value_sections/base_value_section.gd"

@onready var Name     : Label    = self.get_node("Name")
@onready var EditLine : LineEdit = self.get_node("LineEdit")

func get_value():
	return EditLine.text

func load_from_data(data : Dictionary = {}) -> void:
	Name.text = str(data["name"], ": ")
	value_name = data["name"]
	value_type = ValueTypes.SingleLineString
	if data.has("value"):
		EditLine.text = data["value"]
	elif data.has("default"):
		EditLine.text = data["default"]
	if data.has("default"):
		value_default = [data["default"]]
