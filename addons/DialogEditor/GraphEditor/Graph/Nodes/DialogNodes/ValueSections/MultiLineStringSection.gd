tool
extends "res://addons/DialogEditor/GraphEditor/Graph/Nodes/DialogNodes/ValueSections/BaseValueSection.gd"

onready var Text : TextEdit = self.get_node("VBoxContainer/TextEdit")
onready var Name : Label    = self.get_node("VBoxContainer/Label")

func get_value():
	return Text.text

func load_from_data(data : Dictionary = {}) -> void:
	Name.text = str(data["name"], ": ")
	value_name = data["name"]
	value_type = 2
	if data.has("value"):
		Text.text = data["value"]
	if data.has("default"):
		value_default = [data["default"]]
