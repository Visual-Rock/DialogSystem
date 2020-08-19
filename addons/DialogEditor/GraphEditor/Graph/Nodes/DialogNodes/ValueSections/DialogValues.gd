tool
extends VBoxContainer

var value_sections     : Array = [
	load("res://addons/DialogEditor/GraphEditor/Graph/Nodes/DialogNodes/ValueSections/NameSection.tscn"),
	load("res://addons/DialogEditor/GraphEditor/Graph/Nodes/DialogNodes/ValueSections/StringSection.tscn"),
	load("res://addons/DialogEditor/GraphEditor/Graph/Nodes/DialogNodes/ValueSections/MultiLineStringSection.tscn"),
	load("res://addons/DialogEditor/GraphEditor/Graph/Nodes/DialogNodes/ValueSections/BooleanSection.tscn"),
	load("res://addons/DialogEditor/GraphEditor/Graph/Nodes/DialogNodes/ValueSections/NumberSection.tscn")
]

func load_dialog_values(new_values : Array) -> void:
	if new_values.size() != 0:
		var section : HBoxContainer
		for value in new_values:
			if value:
				section = value_sections[value["type"]].instance()
				self.add_child(section)
				section.load_from_data(value)

func get_dialog_values() -> Array:
	var val : Array = []
	if self.get_child_count() != 0:
		for value in self.get_children():
			if value.has_method("get_save_data"):
				val.append( value.get_save_data() )
	return val
