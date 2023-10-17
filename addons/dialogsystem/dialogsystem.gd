@tool
extends EditorPlugin

const DialogEditor: PackedScene = preload("res://addons/dialogsystem/dialog_editor.tscn")

var dialog_window_inst: Control

func _enter_tree():
	dialog_window_inst = DialogEditor.instantiate()
	get_editor_interface().get_editor_main_screen().add_child(dialog_window_inst)
	_make_visible(false)

func _exit_tree():
	if dialog_window_inst:
		dialog_window_inst.queue_free()

func _has_main_screen():
	return true

func _make_visible(visible: bool):
	if dialog_window_inst:
		dialog_window_inst.visible = visible

func _get_plugin_name():
	return "Dialog Editor"

func _get_plugin_icon():
	return get_editor_interface().get_base_control().get_theme_icon("Node", "EditorIcons")
