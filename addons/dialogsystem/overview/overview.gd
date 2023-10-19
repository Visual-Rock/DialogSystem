@tool
extends Control

var manager : DialogManager : set = _on_dialog_manager_set

@onready var dialogs_container : VBoxContainer = self.get_node( "VBoxContainer/Panel/DialogsContainer" )
@onready var add_dialog : ConfirmationDialog = self.get_node( "AddDialog" )
@onready var new_dialog_name : LineEdit = self.get_node( "AddDialog/VBoxContainer/Name" )
@onready var new_dialog_id : SpinBox = self.get_node( "AddDialog/VBoxContainer/HBoxContainer/ID" )
@onready var TemplateSelection : OptionButton = self.get_node("AddDialog/VBoxContainer/OptionButton")
@onready var TempDialogs : Control = self.get_node("VBoxContainer/TempDialogs")

@onready var dialog_entry : PackedScene = preload( "res://addons/dialogsystem/overview/dialog_entry.tscn" )

var graph_editor : Control

func _on_dialog_manager_set( value ) -> void:
	manager = value
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
		entry.connect("delete_dialog", _on_delete_dialog)
		entry.connect("bake_dialog", graph_editor.open_dialog)
		dialogs_container.add_child( entry )

func _on_add_pressed():
	TemplateSelection.clear()
	var i : int = 0
	for template in manager.loaded_templates:
		TemplateSelection.add_item(template.template_name, i)
		i += 1
	new_dialog_id.value = get_free_id()
	add_dialog.show( )

func get_free_id() -> int:
	return manager.loaded_dialogs.reduce(func(max : InternalDialog, val : InternalDialog): return val if val.id > max.id else max).id + 1

func _on_add_dialog_confirmed():
	var dialog : InternalDialog = InternalDialog.new( )
	dialog.init( new_dialog_id.value, new_dialog_name.text, manager.save_path, manager.loaded_templates[TemplateSelection.get_selected_id()])
	manager.loaded_dialogs.append( dialog )
	manager.load_dialogs( )

func _on_select_all_toggled( button_pressed ):
	for child in dialogs_container.get_children( ):
		if child.name != "__AddNewDialog__":
			child.get_node( "Selected" ).button_pressed = button_pressed

func _on_open_selected_pressed():
	for child in dialogs_container.get_children( ):
		if child.name != "__AddNewDialog__":
			if child.get_node( "Selected" ).button_pressed:
				child._on_open_pressed()

func _on_delete_dialog(dialog: InternalDialog) -> void:
	manager.delete_dialog(dialog)

func _on_delete_selected_pressed():
	var to_delete : Array[InternalDialog] = []
	for child in dialogs_container.get_children( ):
		if child.name != "__AddNewDialog__":
			if child.get_node( "Selected" ).button_pressed:
				to_delete.append(child.dialog)
	manager.delete_dialogs(to_delete)

func _on_bake_selected_pressed():
	for child in dialogs_container.get_children( ):
		if child.name != "__AddNewDialog__":
			if child.get_node( "Selected" ).button_pressed:
				if !child.dialog.scene.loaded:
					TempDialogs.add_child(child.dialog.scene)
					TempDialogs.remove_child(child.dialog.scene)
				child.dialog.bake()
