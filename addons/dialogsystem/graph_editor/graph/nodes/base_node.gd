@tool
extends GraphNode

@export var node_id : int = -1
@export var dialog_values : Array[ Dictionary ] = []

@onready var NodeValueContainer = self.get_node("NodeValueContainer")

func apply_template(template: Template) -> void:
	NodeValueContainer.load_template( template.node_values )

func _ready() -> void:
	self.connect("delete_request", _close_base_node_request)
	self.connect("resize_request", _on_resize_request)
	
	var hbox = self.get_titlebar_hbox( )
	var btn = TextureButton.new( )
	btn.connect("pressed", _close_base_node_request)
	btn.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
	var texture = load("res://addons/dialogsystem/icons/Close.svg")
	btn.texture_normal = texture
	btn.texture_pressed = texture
	btn.texture_hover = texture
	btn.texture_disabled = texture
	btn.texture_focused = texture
	hbox.add_child( btn )
	
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

func get_bake_data(id: int) -> Dictionary:
	var dict : Dictionary = {}
	dict["id"] = id
	var values : Array = []
	for c in NodeValueContainer.get_children( ):
		if c.has_method( "get_data" ):
			values.append( c.get_data( ) )
	dict["values"] = values
	dict["type"] = node_id
	return dict

func save() -> void:
	dialog_values = [ ]
	for c in NodeValueContainer.get_children( ):
		if c.has_method( "get_save_data" ):
			dialog_values.append( c.get_save_data( ) )
