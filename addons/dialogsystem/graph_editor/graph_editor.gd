@tool
extends Control

enum DialogOptions {
	New = 0,
	Save = 1,
}

@onready
var GraphTabContainer : TabContainer = self.get_node("VBoxContainer/TabContainer")

@onready
var GrapgNode : PackedScene = preload("res://addons/dialogsystem/graph_editor/graph/graph_edit.tscn")

func open_dialog(dialog: InternalDialog) -> void:
	for c in GraphTabContainer.get_children():
		if (dialog.id == c.dialog.id):
			return
	
	var graph : Node = dialog.scene
	graph.name = dialog.name
	graph.dialog = dialog
	GraphTabContainer.add_child(graph)
