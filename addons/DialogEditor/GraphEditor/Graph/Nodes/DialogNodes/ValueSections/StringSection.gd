extends "res://addons/DialogEditor/GraphEditor/Graph/Nodes/DialogNodes/ValueSections/BaseValueSection.gd"

onready var StringLine : LineEdit = self.get_node("LineEdit")

func get_value():
	return StringLine.text

func load_from_data(data : Dictionary = {}) -> void:
	StringLine.placeholder_text = data["name"]
	value_name = data["name"]
	value_type = 1
	if data.has("value"):
		StringLine.text = data["value"]
	if data.has("default"):
		value_default = [data["default"]]

func get_save_data() -> Dictionary:
	var rtrn : Dictionary = get_data()
	rtrn["default"]  = value_default[0]
	return rtrn
