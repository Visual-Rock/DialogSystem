@tool
extends Control

enum DialogOptions {
	New = 0,
	Save = 1,
}

@onready
var DialogMenu : MenuButton = self.get_node("VBoxContainer/ToolBox/DialogMenu")

@onready
var GraphTabContainer : TabContainer = self.get_node("VBoxContainer/TabContainer")

@onready
var GrapgNode : PackedScene = preload("res://addons/dialogsystem/graph_editor/graph/graph_edit.tscn")

func _ready():
	# DialogMenu.get_popup().connect("id_pressed", dialog_option_pressed)
	pass

func open_dialog(dialog: InternalDialog) -> void:
	for c in GraphTabContainer.get_children():
		if (dialog.id == c.dialog.id):
			return
	
	var graph : Node = dialog.scene
	graph.name = dialog.name
	graph.dialog = dialog
	GraphTabContainer.add_child(graph)

func dialog_option_pressed(id: int) -> void:
	match id:
		DialogOptions.New:
			pass
		DialogOptions.Save:
			for c in GraphTabContainer.get_children():
				c.dialog.save()
	pass
