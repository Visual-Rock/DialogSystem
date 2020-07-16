tool
extends EditorPlugin

# DialogEditor Referencen 
const DialogEditor         : Resource = preload("res://addons/DialogEditor/DialogGraphEditor/DialogGraphEditor.tscn")
var   DialogEditorInstance : Node

# called when Plugin Enters Scene Tree
func _enter_tree() -> void:
	
	# creates DialogEditorInstance
	DialogEditorInstance = DialogEditor.instance()
	
	# gets the Editor Viewport and adds the DialogEditorInstance
	get_editor_interface().get_editor_viewport().add_child(DialogEditorInstance)
	# calls make_visible to make it invisible
	make_visible(false)

# called when Plugin exits the Scene Tree
func _exit_tree() -> void:
	
	# checks if DialogEditorInstance is valid
	if DialogEditorInstance:
		# Queues the Editor for deletion
		DialogEditorInstance.queue_free()

# makes the EditorInstance Visible or Invisible based on Input
func make_visible(visible : bool) -> void:
	# Checks if EditorInstance is valid
	if DialogEditorInstance:
		# sets visibility
		DialogEditorInstance.visible = visible

# Returns name for the Editor Tab
func get_plugin_name() -> String:
	return "Dialog Editor"

# Returns the Icon for the Editor Tab
func get_plugin_icon():
	return get_editor_interface().get_base_control().get_icon("Node", "EditorIcons")

func has_main_screen():
	return true
