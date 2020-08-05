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

var start_node  : GraphNode

export var node_values : Array  = []
export var connections : Array  = []
export var dialog_name : String = ""

func _ready() -> void:
	self.connect("connection_request", self, "connection_request")
	self.connect("disconnection_request", self, "disconnection_request")

# Saves the Graph as a .tscn file
func save_graph() -> void:
	print("Saved Graph with name ", name)

func bake_graph() -> Dictionary:
	if start_node != null:
		editor.debug_message("Started Baking!")
		return start_node.get_dialog()
	else:
		editor.debug_message("No Start Node Detected!")
		return { "node_id": 99 }

# Add Node to Graph
func add_node(node : int) -> void:
	match node:
		NODES.START:
			if start_node != null:
				editor.debug_message("Start Node Already Exists! can't create more than one!")
				return
	var n : GraphNode
	if nodes.has(str(node)) == true:
		n = nodes[str(node)].instance()
	else:
		printerr("Node Does not exists! No Node with Id ", node, " found!")
	if node == NODES.START:
		start_node = n
	if n:
		n.node_values = node_values
		self.add_child(n)

func connection_request(from, from_slot, to, to_slot):
	connect_node(from, from_slot, to, to_slot)
	connections = self.get_connection_list()

func disconnection_request(from, from_slot, to, to_slot):
	disconnect_node(from, from_slot, to, to_slot)
	connections = self.get_connection_list()

func get_right_connected_node(node_name : String, slot : int) -> Dictionary:
	for connection in connections:
		if connection["from"] == node_name && connection["from_port"] == slot:
			return connection
			break
	return {}

func get_left_connected_node(node_name : String, slot : int) -> Dictionary:
	for connection in connections:
		if connection["to"] == node_name && connection["to_slot"]:
			return connection
			break
	return {}
