@tool
extends "res://addons/dialogsystem/graph_editor/graph/nodes/value_sections/base_value_section.gd"

@onready var Name  : Label        = self.get_node("Name")
@onready var Names : OptionButton = self.get_node("OptionButton")

var values 

func get_value():
	return Names.selected

func get_data() -> Dictionary:
	return { "name": value_name, "type": value_type, "value": Names.get_item_text(get_value()) }

func load_from_data(data : Dictionary = {}) -> void:
	Name.text = str(data["name"], ": ")
	value_name = data["name"]
	value_type = ValueTypes.Names
	
	Names.clear( )
	values = data["values"]
	var i : int = 0
	for _name in values:
		Names.add_item(_name, i)
		i += 1
	
	if data.has("default"):
		value_default = [data["default"]]
		Names.selected = value_default[0]
	
	if data.has("selected"):
		Names.selected = data["selected"]

func get_save_data() -> Dictionary:
	var ret : Dictionary = get_data()
	ret["default"]  = value_default[0]
	ret["values"] = values
	ret["selected"] = get_value()
	return ret
