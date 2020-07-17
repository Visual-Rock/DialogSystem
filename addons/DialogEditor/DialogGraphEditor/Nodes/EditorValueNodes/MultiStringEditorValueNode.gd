tool
extends "res://addons/DialogEditor/DialogGraphEditor/Nodes/EditorValueNodes/BaseEditorValueNode.gd"


export (Dictionary) var values = {}

func _ready():
	if values.size() != 0:
		update_node(values)

func update_node(new_values : Dictionary):
	$VBoxContainer/RichTextLabel.text = new_values["value"][0]
	NodeValueName.text = new_values["name"]
	values = new_values

func resize_node(new_minsize) -> void:
	$VBoxContainer/RichTextLabel.rect_min_size = Vector2(new_minsize.x - 32, clamp(new_minsize.y - 54, 50, new_minsize.y))

func get_value() -> String:
	_on_TextureButton_pressed()
	return values["value"]
