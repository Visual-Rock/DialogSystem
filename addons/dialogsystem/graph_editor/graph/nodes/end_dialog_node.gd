@tool
extends "res://addons/dialogsystem/graph_editor/graph/nodes/base_node.gd"

func _ready():
	super._ready()
	self.remove_child(NodeValueContainer)
	add_child( NodeValueContainer )
