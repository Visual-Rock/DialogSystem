tool
extends GraphEdit

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








func _on_GraphEdit_mouse_entered():
	MouseOnNode = true

func _on_GraphEdit_mouse_exited():
	MouseOnNode = false






