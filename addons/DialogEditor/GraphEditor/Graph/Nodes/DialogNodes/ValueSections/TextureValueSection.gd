extends "res://addons/DialogEditor/GraphEditor/Graph/Nodes/DialogNodes/ValueSections/BaseValueSection.gd"

onready var path : HBoxContainer = self.get_node("VBoxContainer/PathSelect")

func get_value():
	return path.get_value()

func load_from_data(data : Dictionary = {}) -> void:
	path.path_name = str(data["name"], ": ")
	value_name = data["name"]
	value_type = 5
	if data.has("value"):
		path.set_value(data["value"])
	if data.has("default"):
		value_default = [data["default"]]
