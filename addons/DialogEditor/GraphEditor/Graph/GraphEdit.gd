tool
extends GraphEdit

enum NODES {
	START = 0,
	TEXT  = 1,
	
	END   = 99,
}

var nodes : Dictionary = {
	"0": load("res://addons/DialogEditor/GraphEditor/Graph/Nodes/DialogNodes/StartDialogNode.tscn"), # Start Node
	"1": load("res://addons/DialogEditor/GraphEditor/Graph/Nodes/DialogNodes/TextDialogNode.tscn"),  # Text Node
}

var editor : Control

export var dialog_name : String = ""

# Saves the Graph as a .tscn file
func save_graph() -> void:
	print("Saved Graph with name ", name)

# Add Node to Graph
func add_node(node : int) -> void:
	print("add Node of type ", node)
