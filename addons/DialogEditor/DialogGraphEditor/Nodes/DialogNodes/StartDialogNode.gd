tool
extends "res://addons/DialogEditor/DialogGraphEditor/Nodes/DialogNodes/BaseDialogNode.gd"


# called when node is resized
func resize_node(new_minsize) -> void:
	$Name/Name.rect_size = Vector2(new_minsize.x - 32, 24)
	$Text/Text.rect_min_size = Vector2(new_minsize.x - 32, clamp(new_minsize.y - 99, 26, new_minsize.y))
