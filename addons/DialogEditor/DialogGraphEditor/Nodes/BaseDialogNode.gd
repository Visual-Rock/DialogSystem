extends GraphNode

signal deleted_node(node_type)

export (int) var NodeIndexNumber

func get_node_type() -> int:
	return NodeIndexNumber

func _on_BaseDialogNode_close_request():
	close_node()
	emit_signal("deleted_node", NodeIndexNumber)

func _on_BaseDialogNode_resize_request(new_minsize):
	resize_node()



# Overwrittabel functions

# called when node closes
func close_node() -> void:
	pass

# called when node is resized
func resize_node() -> void:
	pass

