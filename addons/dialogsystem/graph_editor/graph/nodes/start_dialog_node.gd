extends "res://addons/dialogsystem/graph_editor/graph/nodes/base_node.gd"

signal start_deleted()

func _ready():
	super._ready()
	self.remove_child(NodeValueContainer)
	add_child( NodeValueContainer )

func on_close() -> void:
	emit_signal("start_deleted")
