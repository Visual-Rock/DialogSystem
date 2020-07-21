tool
extends GraphEdit

signal debug_text(text)

enum NODES {
	START     = 0,
	TEXT      = 1,
	END       = 9,
	
	NAME      = 10,
	STRING    = 11,
	MLSTRING  = 12
}

var DialogNodes =  [load("res://addons/DialogEditor/DialogGraphEditor/Nodes/DialogNodes/StartDialogNode.tscn"),
					load("res://addons/DialogEditor/DialogGraphEditor/Nodes/DialogNodes/TextDialogNode.tscn"),
					load("res://addons/DialogEditor/DialogGraphEditor/Nodes/DialogNodes/BranchDialogNode.tscn")]
var ValueNodes  = [ load("res://addons/DialogEditor/DialogGraphEditor/Nodes/EditorValueNodes/NameNode.tscn"),
					load("res://addons/DialogEditor/DialogGraphEditor/Nodes/EditorValueNodes/StringEditorValueNode.tscn"),
					load("res://addons/DialogEditor/DialogGraphEditor/Nodes/EditorValueNodes/MultiStringEditorValueNode.tscn")]


# Stores all Node Connections in an exportet var
export (Array) var connections
export (String) var GraphName
var GraphEditor

var StartNode : GraphNode

var SkipEmptyNodes = true

# is mouse over node
var MouseOnNode : bool = false

# called when childrens and this node entered the SceneTree
func _ready():
	
	for c in self.get_children():
		if c is GraphNode:
			if c.get_node_type() == NODES.START:
				StartNode = c
			elif c.get_node_groupe() == 1:
				c.GraphEditor = GraphEditor
				c._on_TextureButton_pressed()
	
	# checks if the connection array is not an empty array
	if connections != []:
		# goes through the connections array
		for c in connections:
			#connects nodes together
			connect_node(c["from"], c["from_port"], c["to"], c["to_port"])
	
	connections = get_connection_list()

# gets called when user wants to connect two nodes
func _on_GraphEdit_connection_request(from, from_slot, to, to_slot):
	# connects two nodes
	connect_node(from, from_slot, to, to_slot)
	self.get_node(from).update_connections( {"from": from, "from_slot": from_slot, "to": to, "to_slot": to_slot} )
	self.get_node(to).update_connections( {"from": from, "from_slot": from_slot, "to": to, "to_slot": to_slot} )
	connections = get_connection_list()

# gets called when user wants to disconnect two nodes
func _on_GraphEdit_disconnection_request(from, from_slot, to, to_slot):
	# disconnects two nodes
	disconnect_node(from, from_slot, to, to_slot)
	self.get_node(from).update_disconnection( {"from": from, "from_slot": from_slot, "to": to, "to_slot": to_slot} )
	self.get_node(to).update_disconnection( {"from": from, "from_slot": from_slot, "to": to, "to_slot": to_slot} )
	connections = get_connection_list()

# called when to add node
func add_node(node, type, data = null, GraphEditor = null):
	
	if type == "dialog":
		
		if node == NODES.START && StartNode != null:
			emit_signal("debug_text", "StartNode Already Exists")
		else:
			# instances the node
			var n = DialogNodes[node].instance()
			# connects the deleted_node signal to node_deleted
			n.connect("deleted_node", self, "node_deleted")
			# adds the node to self
			self.add_child(n)
			
			# matches the node
			match node:
				# when node is NODES.START (0)
				NODES.START:
					# prints for debuging
					print(" [ Dialog Editor ] added Start Node!")
					StartNode = n
	elif type == "value":
		
		var n = ValueNodes[node].instance()
		n.connect("deleted_node", self, "node_deleted")
		self.add_child(n)
		n.value_id = data["id"]
		n.update_node(data)
		n.GraphEditor = GraphEditor

# called when node is deleted
func node_deleted(node_type):
	match node_type:
		NODES.START:
			StartNode = null

func _on_GraphEdit_mouse_entered():
	MouseOnNode = true

func _on_GraphEdit_mouse_exited():
	MouseOnNode = false

func save_graph() -> void:
	connections = self.get_connection_list()
	var SavePath : String
	var f = File.new()
	if f.file_exists("res://addons/DialogEditor/settings.json"):
		f.open("res://addons/DialogEditor/settings.json", f.READ)
		SavePath = parse_json(f.get_as_text())["SavePath"]
		f.close()
	else:
		SavePath = "res://addons/DialogEditor/Saves/"
	
	if !SavePath.ends_with("/"):
		SavePath = str(SavePath, "/")
	
	var scene = PackedScene.new()
	
	for c in self.get_children():
		if c is GraphNode:
			c.set_owner(self)
	
	scene.pack(self)
	ResourceSaver.save(str(SavePath, GraphName, ".tscn"), scene)

func bake_dialog() -> void:
	
	var f = File.new()
	if f.file_exists("res://addons/DialogEditor/settings.json"):
		f.open("res://addons/DialogEditor/settings.json", f.READ)
		SkipEmptyNodes = parse_json(f.get_as_text())["SkipEmpty"]
		f.close()
	
	if StartNode:
		emit_signal("debug_text", "Start Baking")
		StartNode.get_dialog()
	else:
		emit_signal("debug_text", "No StartNode!")

func get_left_connected_node(node_name, port) -> Dictionary:
	
	for connection in connections:
		if connection["to"] == node_name && connection["to_port"] == port:
			return connection
			break
	return {}

func get_right_connected_node(node_name, port) -> Dictionary:
	for connection in connections:
		if connection["from"] == node_name && connection["from_port"] == port:
			return connection
			break
	return {}

















