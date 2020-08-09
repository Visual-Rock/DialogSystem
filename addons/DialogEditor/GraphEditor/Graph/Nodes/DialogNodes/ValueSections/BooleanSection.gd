tool
extends "res://addons/DialogEditor/GraphEditor/Graph/Nodes/DialogNodes/ValueSections/BaseValueSection.gd"

onready var Checkbox : CheckBox = self.get_node("CheckBox")
onready var Name     : Label    = self.get_node("name")

func get_value():
	return Checkbox.pressed

func load_from_data(data : Dictionary = {}) -> void:
	Name.text = str(data["name"], ": ")
	value_name = data["name"]
	value_type = 3
	if data.has("value"):
		Checkbox.pressed = data["value"]
	elif data.has("default"):
		Checkbox.pressed = data["default"]
	if data.has("default"):
		value_default = [data["default"]]
