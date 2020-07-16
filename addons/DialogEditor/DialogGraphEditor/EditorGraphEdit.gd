tool
extends GraphEdit

enum NODES {
	START
}

var nodes = [load("res://addons/DialogEditor/DialogGraphEditor/Nodes/DialogNodes/StartDialogNode.tscn")]

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

# gets called when user wants to disconnect two nodes
func _on_GraphEdit_disconnection_request(from, from_slot, to, to_slot):
	# disconnects two nodes
	disconnect_node(from, from_slot, to, to_slot)

# called when to add node
func add_node(node):
	
	# instances the node
	var n = nodes[node].instance()
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

# called when node is deleted
func node_deleted(node_type):
	pass




func _on_GraphEdit_mouse_entered():
	MouseOnNode = true

func _on_GraphEdit_mouse_exited():
	MouseOnNode = false






