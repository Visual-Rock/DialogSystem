tool
extends GraphNode

signal deleted_node(node_type)

export (int) var NodeIndexNumber

func get_node_type() -> int:
	return NodeIndexNumber

func _on_BaseDialogNode_close_request():
	close_node()
	emit_signal("deleted_node", NodeIndexNumber)
	self.queue_free()

func _on_BaseDialogNode_resize_request(new_minsize):
	resize_node(new_minsize)
	self.rect_size = new_minsize



# Overwrittabel functions

# called when node closes
func close_node() -> void:
	pass

# called when node is resized
func resize_node(new_minsize) -> void:
	pass

func update_connections(new_connection):
	pass

func update_disconnection(new_disconnection):
	pass

# used for saving
func set_owner(new_owner):
	pass

func get_dialog() -> Dictionary:
	return {}
