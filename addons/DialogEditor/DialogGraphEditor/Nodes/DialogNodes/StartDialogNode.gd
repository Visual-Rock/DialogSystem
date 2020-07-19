tool
extends "res://addons/DialogEditor/DialogGraphEditor/Nodes/DialogNodes/BaseDialogNode.gd"

export (Array) var dialog_connections = []
export (String) var dialog_name = ""
export (String, MULTILINE) var dialog_text = ""

func _ready():
	
	$Name/Name.text = dialog_name
	$Text/Text.text = dialog_text


# called when node is resized
func resize_node(new_minsize) -> void:
	$Name/Name.rect_size = Vector2(new_minsize.x - 32, 24)
	$Text/Text.rect_min_size = Vector2(new_minsize.x - 32, clamp(new_minsize.y - 99, 26, new_minsize.y))

func update_connections(new_connection):
	dialog_connections.append(new_connection)
	if new_connection["to"] == self.name:
		self.get_children()[new_connection["to_slot"]].get_children()[1].hide()
	else:
		pass
	
	.update_connections(new_connection)

func update_disconnection(new_disconnection):
	dialog_connections.erase(new_disconnection)
	if new_disconnection["to"] == self.name:
		if new_disconnection["to_slot"] != 0:
			self.get_children()[new_disconnection["to_slot"]].get_children()[1].show()
	else:
		pass
	
	.update_disconnection(new_disconnection)

func update_data() -> void:
	dialog_name = $Name/Name.text
	dialog_text = $Text/Text.text
	
