@tool
extends VBoxContainer

var sections : Array[ PackedScene ] = [
	load("res://addons/dialogsystem/graph_editor/graph/nodes/value_sections/name_section.tscn"),
	load("res://addons/dialogsystem/graph_editor/graph/nodes/value_sections/single_line_string_section.tscn"),
	load("res://addons/dialogsystem/graph_editor/graph/nodes/value_sections/multi_line_string_section.tscn"),
	load("res://addons/dialogsystem/graph_editor/graph/nodes/value_sections/boolean_section.tscn"),
	load("res://addons/dialogsystem/graph_editor/graph/nodes/value_sections/number_section.tscn"),
]

func _ready():
	pass # Replace with function body.

func load_template(template : Array[ Dictionary ]) -> void:
	# TODO: maybe bring changse there to the new Template
	if self.get_child_count() != 0:
		for c in self.get_children():
			if c is HSeparator:
				pass
			else:
				c.queue_free()
	
	for ts in template:
		var node = sections[ts["type"]].instantiate( )
		self.add_child( node )
		node.load_from_data( ts )

