tool
extends GraphNode

onready var NodeValueName : Label = self.get_node("HBoxContainer/Label")

signal deleted_node(node_type)
export (int) var value_id
export (int) var node_id

var GraphEditor

func _on_BaseEditorValueNode_close_request():
	emit_signal("deleted_node", node_id)
	close_node()
	self.queue_free()

func _on_BaseEditorValueNode_resize_request(new_minsize):
	resize_node(new_minsize)
	self.rect_size = new_minsize

func _on_TextureButton_pressed():
	update_node(GraphEditor.EditorVariables[str(value_id)])

# called when node closes
func close_node() -> void:
	pass

# called when node is resized
func resize_node(new_minsize) -> void:
	pass

func update_node(new_values : Dictionary):
	pass

func update_connections(new_connection):
	pass

func update_disconnection(new_disconnection):
	pass

# used for saving
func set_owner(new_owner):
	pass





