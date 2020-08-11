tool
extends GraphEdit

enum NODES {
	START  = 0,
	TEXT   = 1,
	BRANCH = 2,
	
	END    = 99,
}

var nodes : Dictionary = {
	"0":  load("res://addons/DialogEditor/GraphEditor/Graph/Nodes/DialogNodes/StartDialogNode.tscn"),  # Start Node
	"1":  load("res://addons/DialogEditor/GraphEditor/Graph/Nodes/DialogNodes/TextDialogNode.tscn"),   # Text Node
	"2":  load("res://addons/DialogEditor/GraphEditor/Graph/Nodes/DialogNodes/BranchDialogNode.tscn"), # Branch Node
	"99": load("res://addons/DialogEditor/GraphEditor/Graph/Nodes/DialogNodes/EndDialogNode.tscn")     # End Node
}

var editor : Control

var start_node  : GraphNode

export var node_values : Array  = []
export var connections : Array  = []
export var dialog_name : String = ""

var copy : Array = []

func _ready() -> void:
	self.connect("connection_request", self, "connection_request")
	self.connect("disconnection_request", self, "disconnection_request")
	self.connect("delete_nodes_request", self, "delete_selected_nodes")
	self.connect("copy_nodes_request", self, "copy_selected_nodes")
	self.connect("paste_nodes_request", self, "paste_selected_nodes")
	self.connect("duplicate_nodes_request", self, "duplicate_selected_nodes")
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

func bake_graph(skip_empty : bool) -> Dictionary:
	if start_node != null:
		editor.debug_message("Started Baking!")
		var dialog : Dictionary
		dialog["dialog"] = start_node.get_dialog(skip_empty)
		dialog["value"] = node_values
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

func delete_selected_nodes() -> void:
	for node in self.get_children():
		if node is GraphNode:
			if node.is_selected():
				node.queue_free()

func copy_selected_nodes() -> void:
	copy = []
	for node in self.get_children():
		if node is GraphNode:
			if node.is_selected():
				copy.append(node)

func paste_selected_nodes() -> void:
	print("paste")
	var n    : GraphNode
	var data : Dictionary
	for node in copy:
		data = node.get_paste_data()
		n = nodes[str(data["node_id"])].instance()
		n.dialog_values = data["values"]
		if data["node_id"] == 2:
			n.branch_type = data["branch_type"]
			n.branch_values = data["options"]
			n.branch_amount = data["options"].size()
		n.offset = node.offset
		n.offset.y += 30
		n.offset.x += 20
		n.selected = true
		node.selected = false
		self.add_child(n)

func duplicate_selected_nodes() -> void:
	copy_selected_nodes()
	paste_selected_nodes()








