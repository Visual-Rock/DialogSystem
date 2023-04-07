@tool
extends GraphNode

func _ready() -> void:
	connect("close_request", _close_base_node_request)
	connect("resize_request", _on_resize_request)

func _close_base_node_request() -> void:
	on_close()
	queue_free()

func _on_resize_request(new_size) -> void:
	custom_minimum_size = new_size
	on_resize(new_size)

func on_close() -> void:
	pass

func on_resize(new_size) -> void:
	pass

func save() -> void:
	pass

