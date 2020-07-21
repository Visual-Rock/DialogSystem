tool
extends "res://addons/DialogEditor/DialogGraphEditor/Nodes/EditorValueNodes/BaseEditorValueNode.gd"

onready var NameSection : HBoxContainer = self.get_node("VBoxContainer/HBoxContainer")

var Names : OptionButton

export (String) var value = ""

func _ready():
	_on_TextureButton_pressed()

func update_node(new_values : Dictionary):
	
	if Names:
		value = Names.get_item_metadata(Names.selected)
		Names.queue_free()
	
	var ob : OptionButton = OptionButton.new()
	ob.size_flags_horizontal = SIZE_EXPAND_FILL
	
	if new_values != {}:
		for _value in new_values["value"]:
			ob.add_item(_value, ob.get_item_count())
			if _value == value:
				ob.selected = ob.get_item_count() - 1
			ob.set_item_metadata(ob.get_item_count() - 1, _value)
	
	Names = ob
	NameSection.add_child(ob)
	NodeValueName.text = new_values["name"]

func get_value() -> String:
	_on_TextureButton_pressed()
	return Names.get_item_metadata(Names.selected)
