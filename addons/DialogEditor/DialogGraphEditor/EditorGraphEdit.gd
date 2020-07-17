tool
extends GraphEdit

enum NODES {
	START
}

var DialogNodes =  [load("res://addons/DialogEditor/DialogGraphEditor/Nodes/DialogNodes/StartDialogNode.tscn"),
					load("res://addons/DialogEditor/DialogGraphEditor/Nodes/DialogNodes/TextDialogNode.tscn"),
					load("res://addons/DialogEditor/DialogGraphEditor/Nodes/DialogNodes/BranchDialogNode.tscn")]
var ValueNodes  = [ load("res://addons/DialogEditor/DialogGraphEditor/Nodes/EditorValueNodes/NameNode.tscn"),
					load("res://addons/DialogEditor/DialogGraphEditor/Nodes/EditorValueNodes/StringEditorValueNode.tscn"),
					load("res://addons/DialogEditor/DialogGraphEditor/Nodes/EditorValueNodes/MultiStringEditorValueNode.tscn")]
# Stores all Node Connections in an exportet var
export (Array) var connections

# is mouse over node
var MouseOnNode : bool = false

# called when childrens and this node entered the SceneTree
func _ready():
	
	# checks if the connection array is not an empty array
	if connections != []:
		# goes through the connections array
		for c in connections:
			#connects nodes together
			connect_node(c["from"], c["from_port"], c["to"], c["to_port"])

# gets called when user wants to connect two nodes
func _on_GraphEdit_connection_request(from, from_slot, to, to_slot):
	# connects two nodes
	connect_node(from, from_slot, to, to_slot)
	self.get_node(from).update_connections( {"from": from, "from_slot": from_slot, "to": to, "to_slot": to_slot} )
	self.get_node(to).update_connections( {"from": from, "from_slot": from_slot, "to": to, "to_slot": to_slot} )

# gets called when user wants to disconnect two nodes
func _on_GraphEdit_disconnection_request(from, from_slot, to, to_slot):
	# disconnects two nodes
	disconnect_node(from, from_slot, to, to_slot)
	self.get_node(from).update_disconnection( {"from": from, "from_slot": from_slot, "to": to, "to_slot": to_slot} )
	self.get_node(to).update_disconnection( {"from": from, "from_slot": from_slot, "to": to, "to_slot": to_slot} )

# called when to add node
func add_node(node, type, data = null, GraphEditor = null):
	
	if type == "dialog":
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
	elif type == "value":
		
		var n = ValueNodes[node].instance()
		n.connect("deleted_node", self, "node_deleted")
		self.add_child(n)
		n.value_id = data["id"]
		n.update_node(data)
		n.GraphEditor = GraphEditor

# called when node is deleted
func node_deleted(node_type):
	pass

func _on_GraphEdit_mouse_entered():
	MouseOnNode = true

func _on_GraphEdit_mouse_exited():
	MouseOnNode = false









