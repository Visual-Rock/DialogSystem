tool
extends Panel

signal dialog_node_create(node_type, node_position)

onready var NodeTree : Tree = self.get_node("VBoxContainer/ScrollContainer/VBoxContainer/Tree")

var TreeRoot    : TreeItem
var DialogNodes : TreeItem
var EditorVars  : TreeItem

func _ready():
	TreeRoot = NodeTree.create_item()
	DialogNodes = NodeTree.create_item(TreeRoot)
	DialogNodes.set_text(0, "Dialog Nodes")
	EditorVars = NodeTree.create_item(TreeRoot)
	EditorVars.set_text(0, "Editor Variables")

func show_up():
	self.show()

func add_dialog_node(node_name, node_type): 
	var n : TreeItem = NodeTree.create_item(DialogNodes)
	n.set_text(0, node_name)
	n.set_metadata(0, node_type)

func _on_TextureButton_pressed():
	self.hide()

func _on_Tree_cell_selected():
	var parent = NodeTree.get_selected().get_parent()
	if parent == DialogNodes:
		emit_signal("dialog_node_create", NodeTree.get_selected().get_metadata(0), self.rect_position)
	pass # Replace with function body.
