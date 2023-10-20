@tool
extends GraphEdit

enum NODES {
	START = 1,
	TEXT = 2,
	BRANCH = 3,
	END = 99
}

@onready var MenuPopup : Popup

@export var node_values: Array = [ ]
@export var connections: Array = [ ]

var dialog: InternalDialog

var StartNode : GraphNode = null

var nodes : Array[ PackedScene ] = [
	load("res://addons/dialogsystem/graph_editor/graph/nodes/start_dialog_node.tscn"),
	load("res://addons/dialogsystem/graph_editor/graph/nodes/text_node.tscn"),
	load("res://addons/dialogsystem/graph_editor/graph/nodes/branch_dialog_node.tscn"),
	load("res://addons/dialogsystem/graph_editor/graph/nodes/end_dialog_node.tscn")
]

var copy : Array[ GraphNode ] = [ ]
var loaded : bool = false

func _ready():
	MenuPopup = load("res://addons/dialogsystem/graph_editor/graph/graph_menu.tscn").instantiate()
	self.add_child(MenuPopup)
	MenuPopup.connect("button_pressed", add_node)
	
	# self.connect("popup_request", _on_popup_request)
	
	if (!connections.is_empty()):
		for connection in connections:
			connect_node(connection["from_node"], connection["from_port"], connection["to_node"], connection["to_port"])
	
	for c in self.get_children( true ):
		if c.name.contains("GraphEditFilter"):
			for gc in c.get_children( true ):
				if gc is PanelContainer:
					for pcc in gc.get_children( true ):
						if pcc is HBoxContainer:
							var save = Button.new( )
							save.text = "Save"
							save.connect("pressed", _on_dialog_save)
							pcc.add_child( save )
							
							var close = Button.new( )
							close.text = "Close"
							close.connect("pressed", _on_dialog_close)
							pcc.add_child( close )
							
							var bake = Button.new( )
							bake.text = "Bake"
							bake.connect("pressed", _on_dialog_bake)
							pcc.add_child( bake )
		elif c is GraphNode:
			if c.node_id == 0:
				StartNode = c
	loaded = true

func _on_connection_request(from_node, from_port, to_node, to_port):
	connect_node(from_node, from_port, to_node, to_port)
	connections = self.get_connection_list()


func _on_disconnection_request(from_node, from_port, to_node, to_port):
	disconnect_node(from_node, from_port, to_node, to_port)
	connections = self.get_connection_list()

func _on_delete_nodes_request(nodes):
	for node in self.get_children():
		if node is GraphNode:
			if node.is_selected():
				node.queue_free()

func _on_copy_nodes_request():
	copy = []
	for node in self.get_children():
		if node is GraphNode:
			if node.is_selected():
				copy.append(node)

func _on_paste_nodes_request():
	var n    : GraphNode
	var data : Dictionary
	for node in copy:
		# data = node.get_paste_data()
		n = nodes[node.node_id].instantiate()
		#n.dialog_values = data["values"]
		#if data["node_id"] == 2:
		#	n.branch_type = data["branch_type"]
		#	n.branch_values = data["options"]
		#	n.branch_amount = data["options"].size()
		n.position_offset = node.position_offset
		n.position_offset.y += 30
		n.position_offset.x += 20
		n.selected = true
		node.selected = false
		self.add_child(n)

func _on_duplicate_nodes_request( ):
	_on_copy_nodes_request( )
	_on_paste_nodes_request( )

func _on_popup_request(position):
	# position.y += 100
	var rect = Rect2(position + global_position, Vector2(0, 0))
	MenuPopup.popup(rect)

func add_node(idx: int) -> void:
	var new_node : GraphNode = nodes[idx].instantiate( )
	if idx == 0:
		new_node.connect("start_deleted", _on_start_deleted)
		StartNode = new_node
	if idx == 2: # Branch Node
		new_node.branch_template = dialog.template.branch_values
	self.add_child(new_node)
	new_node.apply_template(dialog.template)
	new_node.owner = self
	var mouse_pos : Vector2 = get_local_mouse_position()
	new_node.position_offset = Vector2(mouse_pos.x + scroll_offset.x, mouse_pos.y + scroll_offset.y)

func _on_start_deleted( ) -> void:
	StartNode = null

func _on_dialog_save( ) -> void:
	dialog.save( )

func save_graph( ) -> void:
	for c in self.get_children( ):
		if c is GraphNode:
			c.save( )

func _on_dialog_close( ) -> void:
	_on_dialog_save( )
	var parent = self.get_parent( )
	parent.remove_child( self )

func _on_dialog_bake( ) -> void:
	dialog.bake()

func bake() -> void:
	if StartNode != null:
		var out : Dictionary = {}
		var nodes : Array[Dictionary] = []
		var id : int = 0
		
		nodes.append(StartNode.get_bake_data(0))
		
		
		out["nodes"] = nodes
		out["start"] = 0
	
	pass

func get_connected_nodes(node : String) -> Array[ Dictionary ]:
	var arr : Array[Dictionary] = []
	for connection in connections:
		if connection["from_node"] == node:
			arr.append(connection)
	return arr





















