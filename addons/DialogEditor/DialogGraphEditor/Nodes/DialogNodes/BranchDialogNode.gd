tool
extends "res://addons/DialogEditor/DialogGraphEditor/Nodes/DialogNodes/BaseDialogNode.gd"

onready var Text : TextEdit = self.get_node("Text/TextEdit")

# called when node is resized
func resize_node(new_minsize) -> void:
	Text.rect_min_size = Vector2(new_minsize.x - 32, clamp(new_minsize.y - 120, 26, new_minsize.y))
