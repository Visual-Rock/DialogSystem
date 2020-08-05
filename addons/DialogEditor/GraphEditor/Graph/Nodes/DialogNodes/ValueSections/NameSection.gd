tool
extends "res://addons/DialogEditor/GraphEditor/Graph/Nodes/DialogNodes/ValueSections/BaseValueSection.gd"

onready var ValueName : Label = self.get_node("Label")
onready var NameMenu  : OptionButton = self.get_node("OptionButton")

func get_value() -> int:
	return NameMenu.selected

func load_from_data(data : Dictionary = {}) -> void:
	ValueName.text = data["name"]
	value_name = data["name"]
	value_type = 0
	NameMenu.clear()
	var i : int = 0
	for _name in data["value"]:
		NameMenu.add_item(_name, i)
		i += 1
