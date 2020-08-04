tool
extends "res://addons/DialogEditor/GraphEditor/Graph/Nodes/BaseNode.gd"

export var node_value_start : int = 2

var value_sections : Array = [
	load("res://addons/DialogEditor/GraphEditor/Graph/Nodes/DialogNodes/ValueSections/NameSection.tscn"),
	load("res://addons/DialogEditor/GraphEditor/Graph/Nodes/DialogNodes/ValueSections/StringSection.tscn"),
	load("res://addons/DialogEditor/GraphEditor/Graph/Nodes/DialogNodes/ValueSections/MultiLineStringSection.tscn")
]

var node_values : Array = []

func _ready() -> void:
	set_node_values([{"type": 0},{"type": 1},{"type": 2}])

func set_node_values(new_values : Array = node_values) -> void:
	if self.get_child_count() - node_value_start != 0:
		var values : Array = self.get_children()
		for value in values:
			if value.has_method("get_value"):
				value.queue_free()
	
	if new_values.size() != 0:
		for value in new_values:
			self.add_child(value_sections[value["type"]].instance())
