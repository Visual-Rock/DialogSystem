tool
extends "res://addons/DialogEditor/GraphEditor/Graph/Nodes/BaseNode.gd"

export var node_id          : int   = -1
export var node_value_start : int   = 2
export var dialog_values    : Array = []
export var dialogs_values   : Array = []
export var include_values   : bool  = true

var settings_save_path : String = "res://addons/DialogEditor/settings.json"
var value_sections     : Array = [
	load("res://addons/DialogEditor/GraphEditor/Graph/Nodes/DialogNodes/ValueSections/NameSection.tscn"),
	load("res://addons/DialogEditor/GraphEditor/Graph/Nodes/DialogNodes/ValueSections/StringSection.tscn"),
	load("res://addons/DialogEditor/GraphEditor/Graph/Nodes/DialogNodes/ValueSections/MultiLineStringSection.tscn"),
	load("res://addons/DialogEditor/GraphEditor/Graph/Nodes/DialogNodes/ValueSections/BooleanSection.tscn"),
	load("res://addons/DialogEditor/GraphEditor/Graph/Nodes/DialogNodes/ValueSections/NumberSection.tscn"),
	load("res://addons/DialogEditor/GraphEditor/Graph/Nodes/DialogNodes/ValueSections/TextureValueSection.tscn"),
	load("res://addons/DialogEditor/GraphEditor/Graph/Nodes/DialogNodes/ValueSections/SoundValueSection.tscn")
]

var node_values   : Array = []

func _ready() -> void:
	if dialog_values.size() != 0:
		set_node_values(dialog_values)
	else:
		set_node_values()
	
	if node_id == 0:
		var dd : VBoxContainer = load("res://addons/DialogEditor/GraphEditor/Graph/Nodes/DialogNodes/ValueSections/DialogValues.tscn").instance()
		self.add_child(HSeparator.new())
		self.add_child(dd)
		if dialogs_values == []:
			var f : File = File.new()
			if f.file_exists(get_dialog_template_path()):
				f.open(get_dialog_template_path(), f.READ)
				dd.load_dialog_values(parse_json(f.get_as_text())["node_values"])
				f.close()
			else:
				dd.load_dialog_values([])
		else:
			dd.load_dialog_values(dialogs_values)

func set_node_values(new_values : Array = node_values) -> void:
	if self.get_child_count() - node_value_start != 0:
		var values : Array = self.get_children()
		for value in values:
			if value.has_method("get_value"):
				value.queue_free()
	
	if new_values.size() != 0:
		var section : HBoxContainer
		for value in new_values:
			if value:
				section = value_sections[value["type"]].instance()
				self.add_child(section)
				section.load_from_data(value)

func get_dialog(skip_empty : bool = true) -> Dictionary:
	
	var rtrn : Dictionary = {}
	var val  : Array      = []
	
	if values_all_default() && skip_empty:
		rtrn["node_id"] = 98
	else:
		rtrn["node_id"] = node_id
		if self.get_child_count() - node_value_start != 0:
			var values : Array = self.get_children()
			if include_values == true:
				for value in values:
					if value.has_method("get_value"):
						val.append( { "name": value.get_value_name(), "value": value.get_value() } )
				rtrn["value"]  = val
	rtrn["options"] = get_options(skip_empty)
	return rtrn

func values_all_default() -> bool:
	if self.get_child_count() - node_value_start != 0:
		var values : Array = self.get_children()
		for value in values:
			if value.has_method("is_default_value"):
				if !value.is_default_value():
					return false
					break
	return true

func get_options(skip_empty : bool) -> Dictionary:
	var rtrn : Dictionary = {}
	var right_node : Dictionary = get_parent().get_right_connected_node(name, 0)
	if right_node.has("from"):
		rtrn["0"] = get_parent().get_node(str(right_node["to"])).get_dialog(skip_empty)
	else:
		rtrn["0"] = { "node_id": 99 }
	return rtrn

func save_node() -> void:
	var val : Array = []
	if self.get_child_count() - node_value_start != 0:
		var values : Array = self.get_children()
		for value in values:
			if value.has_method("get_save_data"):
				val.append( value.get_save_data() )
			elif value.has_method("get_dialog_values"):
				dialogs_values = value.get_dialog_values()
	dialog_values = val

func get_paste_data() -> Dictionary:
	var val : Array = []
	if self.get_child_count() - node_value_start != 0:
		var values : Array = self.get_children()
		for value in values:
			if value.has_method("get_save_data"):
				val.append( value.get_save_data() )
	
	return { "node_id": node_id, "values": val }

func node_group() -> int:
	return 0

func get_node_id() -> int:
	return node_id

func get_dialog_template_path() -> String:
	var rtrn : String = ""
	var f : File = File.new()
	# Checks if settings file exists
	if f.file_exists(settings_save_path):
		# opens the Settings File in Read mode
		f.open(settings_save_path, f.READ)
		# parses the JSON data into a data Variable
		var data = parse_json(f.get_as_text())
		rtrn = data["DefaultDialogTemplate"]
	return rtrn

func get_dialog_values() -> Array:
	if self.get_child_count() - node_value_start != 0:
		var values : Array = self.get_children()
		for value in values:
			if value.has_method("get_bake_data"):
				return value.get_bake_data()
				break
	return []
