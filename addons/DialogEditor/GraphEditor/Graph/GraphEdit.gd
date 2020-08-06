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
	if connections.size() != 0:
		for c in connections:
			connect_node(c["from"], c["from_port"], c["to"], c["to_port"])
	for node in self.get_children():
		if node is GraphNode:
			if node.node_group() == 0:
				if node.get_node_id() == 0:
					start_node = node

# Saves the Graph as a .tscn file
func save_graph() -> void:
	var scene : PackedScene = PackedScene.new()
	for child in self.get_children():
		if child is GraphNode:
			child.save_node()
			child.set_owner(self)
	scene.pack(self)
	print(str(editor.save_path, dialog_name, ".tscn"))
	ResourceSaver.save(str(editor.save_path, dialog_name, ".tscn"), scene)

func bake_graph() -> Dictionary:
	if start_node != null:
		editor.debug_message("Started Baking!")
		var dialog : Dictionary
		dialog["dialog"] = start_node.get_dialog()
		dialog["values"] = node_values
		return dialog
	else:
		editor.debug_message("No Start Node Detected!")
		printerr("No Start node on ", dialog_name, " found!")
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
