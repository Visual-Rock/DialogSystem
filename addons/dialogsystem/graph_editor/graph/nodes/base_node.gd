@tool
extends GraphNode

@export var node_id : int = -1
@export var dialog_values : Array[ Dictionary ] = []

@onready var NodeValueContainer = self.get_node("NodeValueContainer")

func apply_template(template: Template) -> void:
	NodeValueContainer.load_template( template.node_values )

func _ready() -> void:
	self.connect("close_request", _close_base_node_request)
	self.connect("resize_request", _on_resize_request)
	if !dialog_values.is_empty( ):
		NodeValueContainer.load_template( dialog_values )

func _close_base_node_request() -> void:
	on_close()
	queue_free()

func _on_resize_request(new_size) -> void:
	get_rect().size = new_size
	on_resize(new_size)

func on_close() -> void:
	pass

func on_resize(new_size) -> void:
	pass

func save() -> void:
	dialog_values = [ ]
	for c in NodeValueContainer.get_children( ):
		if c.has_method( "get_save_data" ):
			dialog_values.append( c.get_save_data( ) )
