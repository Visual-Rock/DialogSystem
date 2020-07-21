tool
extends "res://addons/DialogEditor/DialogGraphEditor/Nodes/DialogNodes/BaseDialogNode.gd"

export (Array) var dialog_connections = []
export (Dictionary) var data = {}

# called when node is resized
func resize_node(new_minsize) -> void:
	$Text/TextEdit.rect_min_size = Vector2(new_minsize.x - 32, clamp(new_minsize.y - 99, 26, new_minsize.y))

func update_connections(new_connection):
	pass

func update_disconnection(new_disconnection):
	pass

func update_data() -> void:
	for c in self.get_children():
		var nc : Array = c.get_children()
		if nc.size() != 0:
			data[nc[0].text] = nc[1].text
