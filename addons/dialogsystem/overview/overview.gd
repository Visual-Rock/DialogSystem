@tool
extends Control

var manager : DialogManager 

@onready var dialogs_container : VBoxContainer = self.get_node( "VBoxContainer/Panel/DialogsContainer" )
@onready var add_dialog : ConfirmationDialog = self.get_node( "AddDialog" )
@onready var new_dialog_name : LineEdit = self.get_node( "AddDialog/VBoxContainer/Name" )
@onready var new_dialog_id : SpinBox = self.get_node( "AddDialog/VBoxContainer/HBoxContainer/ID" )

@onready var dialog_entry : PackedScene = preload( "res://addons/dialogsystem/overview/dialog_entry.tscn" )

var graph_editor : Control

func _ready( ):
	if manager:
		manager.connect( "dialogs_changed", on_dialogs_changed )

func on_dialogs_changed( ) -> void:
	for child in dialogs_container.get_children( ):
		if child.name != "__AddNewDialog__":
			child.queue_free( )
	populate_dialogs( )

func populate_dialogs( ) -> void:
	for dialog in manager.loaded_dialogs:
		var entry : HBoxContainer = dialog_entry.instantiate( )
		entry.dialog = dialog
		entry.connect("open_dialog", graph_editor.open_dialog)
		dialogs_container.add_child( entry )

func _on_add_pressed():
	add_dialog.show( )

func _on_add_dialog_confirmed():
	var dialog : Dialog = Dialog.new( )
	dialog.init( new_dialog_id.value, new_dialog_name.text, manager.save_path, manager.loaded_templates[0])
	manager.loaded_dialogs.append( dialog )
	manager.load_dialogs( )

func _on_select_all_toggled( button_pressed ):
	for child in dialogs_container.get_children( ):
		if child.name != "__AddNewDialog__":
			child.get_node( "Selected" ).button_pressed = button_pressed
