tool
extends "res://addons/DialogEditor/GraphEditor/Graph/Nodes/DialogNodes/ValueSections/BaseValueSection.gd"

onready var ValueBox : SpinBox = self.get_node("SpinBox")
onready var Name     : Label   = self.get_node("name")

func get_value():
	return ValueBox.value

func load_from_data(data : Dictionary = {}) -> void:
	Name.text = str(data["name"], ": ")
	value_name = data["name"]
	value_type = 4
	ValueBox.step = data["step"]
	ValueBox.min_value = data["min"]
	ValueBox.max_value = data["max"]
	if data.has("value"):
		ValueBox.value = data["value"]
	if data.has("default"):
		value_default = [data["default"]]

func get_save_data() -> Dictionary:
	var rtrn : Dictionary = self.get_data()
	rtrn["step"] = ValueBox.step
	rtrn["min"]  = ValueBox.min_value
	rtrn["max"]  = ValueBox.max_value
	return rtrn
