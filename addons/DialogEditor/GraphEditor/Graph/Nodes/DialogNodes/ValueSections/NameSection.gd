tool
extends "res://addons/DialogEditor/GraphEditor/Graph/Nodes/DialogNodes/ValueSections/BaseValueSection.gd"

onready var ValueName : Label = self.get_node("Label")
onready var NameMenu  : OptionButton = self.get_node("OptionButton")

var name_count : int = 0

func get_value() -> int:
	return NameMenu.selected

func get_dialog_value() -> Dictionary:
	return { "name": value_name, "type": value_type, "value": NameMenu.get_item_text(get_value()) }

func load_from_data(data : Dictionary = {}) -> void:
	ValueName.text = data["name"]
	value_name = data["name"]
	value_type = 0
	NameMenu.clear()
	var i : int = 0
	name_count = 0
	for _name in data["value"]:
		NameMenu.add_item(_name, i)
		name_count += 1
		i += 1
	if data.has("default"):
		value_default = [data["default"]]
	if data.has("selected"):
		NameMenu.selected = data["selected"]

func get_save_data() -> Dictionary:
	var rtrn : Dictionary = self.get_data()
	var val : Array = []
	var nc : int = name_count
	
	while nc != 0:
		val.append(NameMenu.get_item_text(nc - 1))
		nc -= 1
	val.invert()
	rtrn["selected"] = rtrn["value"]
	rtrn["value"]    = val
	rtrn["default"]  = value_default[0]
	
	return rtrn

func get_value_data() -> Dictionary:
	var rtrn : Dictionary = self.get_data()
	var val : Array = []
	var nc : int = name_count
	
	while nc != 0:
		val.append(NameMenu.get_item_text(nc - 1))
		nc -= 1
	val.invert()
	rtrn["value"]    = val
	
	return rtrn
