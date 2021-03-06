tool
extends GraphNode

func _ready():
	# connects all signals
	self.connect("close_request", self, "_on_BaseNode_close_request")
	self.connect("resize_request", self, "_on_BaseNode_resize_request")

func _on_BaseNode_close_request():
	on_close()
	self.queue_free()

func _on_BaseNode_resize_request(new_minsize):
	self.rect_size = new_minsize
	on_resize(new_minsize)

func on_close() -> void:
	pass

func on_resize(new_minsize) -> void:
	pass

func set_owner(new_owner : Node) -> void:
	self.owner = new_owner
	save_node()

func save_node() -> void:
	pass

func node_group() -> int:
	return -1
