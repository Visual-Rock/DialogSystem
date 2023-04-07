@tool
extends GraphEdit

enum NODES {
	START = 1,
	TEXT = 2,
	BRANCH = 3,
	END = 99
}

@export var node_values: Array = [ ]
@export var connections: Array = [ ]
@export var dialog_name: String = ""

func _ready():
	if (!connections.is_empty()):
		for connection in connections:
			connect_node(connection["from"], connection["from_port"], connection["to"], connection["to_port"])
		

func _on_connection_request(from_node, from_port, to_node, to_port):
	pass # Replace with function body.


func _on_disconnection_request(from_node, from_port, to_node, to_port):
	pass # Replace with function body.


func _on_delete_nodes_request(nodes):
	pass # Replace with function body.


func _on_copy_nodes_request():
	pass # Replace with function body.


func _on_paste_nodes_request():
	pass # Replace with function body.


func _on_duplicate_nodes_request():
	pass # Replace with function body.
