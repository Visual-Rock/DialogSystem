tool
extends "res://addons/DialogEditor/GraphEditor/Graph/Nodes/BaseNode.gd"

export var node_id          : int   = -1
export var node_value_start : int   = 2
export var dialog_values    : Array = []

var value_sections : Array = [
	load("res://addons/DialogEditor/GraphEditor/Graph/Nodes/DialogNodes/ValueSections/NameSection.tscn"),
	load("res://addons/DialogEditor/GraphEditor/Graph/Nodes/DialogNodes/ValueSections/StringSection.tscn"),
	load("res://addons/DialogEditor/GraphEditor/Graph/Nodes/DialogNodes/ValueSections/MultiLineStringSection.tscn")
]

var node_values   : Array = []

func _ready() -> void:
	if dialog_values.size() != 0:
		set_node_values(dialog_values)
	else:
		set_node_values()

func set_node_values(new_values : Array = node_values) -> void:
	if self.get_child_count() - node_value_start != 0:
		var values : Array = self.get_children()
		for value in values:
			if value.has_method("get_value"):
				value.queue_free()
	
	if new_values.size() != 0:
		var section : HBoxContainer
		for value in new_values:
			section = value_sections[value["type"]].instance()
			self.add_child(section)
			section.load_from_data(value)
	
	print("node values set!", new_values)

func get_dialog(skip_empty : bool = true) -> Dictionary:
	
	var rtrn : Dictionary = {}
	var val  : Array      = []
	
	if values_all_default() && skip_empty:
		# Skip Node
		pass
	else:
		rtrn["node_id"] = node_id
		if self.get_child_count() - node_value_start != 0:
			var values : Array = self.get_children()
			for value in values:
				if value.has_method("get_value"):
					val.append( { "name": value.get_value_name(), "value": value.get_value() } )
	
	rtrn["options"] = get_options()
	rtrn["values"]  = val
	return rtrn

func values_all_default() -> bool:
	if self.get_child_count() - node_value_start != 0:
		var values : Array = self.get_children()
		for value in values:
			if !value.has_method("is_default_value"):
				return false
				break
	return true

func get_options() -> Array:
	var rtrn : Array = []
	var right_node : Dictionary = get_parent().get_right_connected_node(name, 0)
	print("right connection! ", right_node)
	if right_node.has("from"):
		rtrn.append(get_parent().get_node(str(right_node["to"])).get_dialog())
	else:
		rtrn.append( { "node_id": 99 } )
	return rtrn

func save_node() -> void:
	var val : Array = []
	if self.get_child_count() - node_value_start != 0:
		var values : Array = self.get_children()
		for value in values:
			if value.has_method("get_value"):
				val.append( value.get_save_data() )
	dialog_values = val

func node_group() -> int:
	return 0

func get_node_id() -> int:
	return node_id


