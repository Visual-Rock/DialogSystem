tool
extends "res://addons/DialogEditor/DialogGraphEditor/Nodes/EditorValueNodes/BaseEditorValueNode.gd"

onready var NameSection : HBoxContainer = self.get_node("VBoxContainer/HBoxContainer")

var Names : OptionButton

export (Dictionary) var values = {}

func _ready():
	if values.size() != 0:
		update_node(values)

func update_node(new_values : Dictionary):
	
	var selected_item = ""
	
	if Names:
		selected_item = Names.get_item_metadata(Names.selected)
		Names.queue_free()
	
	var ob : OptionButton = OptionButton.new()
	ob.size_flags_horizontal = SIZE_EXPAND_FILL
	
	if new_values != {}:
		for value in new_values["value"]:
			ob.add_item(value, ob.get_item_count())
			if value == selected_item:
				ob.selected = ob.get_item_count() - 1
			ob.set_item_metadata(ob.get_item_count() - 1, value)
	
	Names = ob
	NameSection.add_child(ob)
	NodeValueName.text = new_values["name"]

func get_value() -> String:
	_on_TextureButton_pressed()
	return Names.get_item_metadata(Names.selected)
