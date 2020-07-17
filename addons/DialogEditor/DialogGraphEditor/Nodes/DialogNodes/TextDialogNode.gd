tool
extends "res://addons/DialogEditor/DialogGraphEditor/Nodes/DialogNodes/BaseDialogNode.gd"

export (String) var dialog_name = ""
export (String, MULTILINE) var dialog_text = ""
export (Array) var dialog_connections = []

# called when node is resized
func resize_node(new_minsize) -> void:
	$Text/TextEdit.rect_min_size = Vector2(new_minsize.x - 32, clamp(new_minsize.y - 99, 26, new_minsize.y))

func update_connections(new_connection):
	dialog_connections.append(new_connection)
	if new_connection["to"] == self.name:
		if new_connection["to_slot"] != 0:
			self.get_children()[new_connection["to_slot"]].get_children()[1].hide()
	else:
		pass
	
	print("new connection", new_connection)

func update_disconnection(new_disconnection):
	dialog_connections.erase(new_disconnection)
	if new_disconnection["to"] == self.name:
		if new_disconnection["to_slot"] != 0:
			self.get_children()[new_disconnection["to_slot"]].get_children()[1].show()
	else:
		pass
	
	print("new disconnection ", new_disconnection)
